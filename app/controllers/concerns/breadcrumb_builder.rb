# frozen_string_literal: true

# Builds UI breadcrumbs for the Loaf gem
module BreadcrumbBuilder
  extend ActiveSupport::Concern

  # Builds the breadcrumbs for a category tree with an optional leaf-concept
  def breadcrumbs_for(category_leaf:, concept: nil)
    # start with the root
    breadcrumb 'home', categories_path, match: :exact

    # build the breadcrumbs for the category's parent-tree
    category_leaf.ancestors.each do |category|
      breadcrumb category.name, category_path(category)
    end

    # ancestors doesn't include the leaf category (just it's parents)
    breadcrumb category_leaf.name, category_path(category_leaf)

    # finally, add the concept if it's there
    breadcrumb concept.name, concept_path(concept) if concept.present?
  end
end
