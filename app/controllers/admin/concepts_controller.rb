# frozen_string_literal: true

module Admin
  class ConceptsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      search_term = params[:search].to_s.strip
      resources = find_resources(search_term)
      resources = apply_resource_includes(resources)
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
      }
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Concept.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

  private

    def find_resources(search_term = nil)
      return Concept.all if search_term.blank?

      Concept.where(id: PgSearch.multisearch(search_term)
                                .where(searchable_type: 'Concept')
                                .pluck(:searchable_id))
             .includes(:translations, category: :translations)
    end
  end
end
