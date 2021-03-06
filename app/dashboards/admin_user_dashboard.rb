# frozen_string_literal: true

require 'administrate/base_dashboard'

class AdminUserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String.with_options(searchable: false),
    email: Field::String,
    password: Field::Password,
    password_confirmation: Field::Password,
    deactivated_at: Field::DateTime.with_options(timezone: 'GB'),
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime.with_options(timezone: 'GB'),
    remember_created_at: Field::DateTime.with_options(timezone: 'GB'),
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime.with_options(timezone: 'GB'),
    last_sign_in_at: Field::DateTime.with_options(timezone: 'GB'),
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    created_at: Field::DateTime.with_options(timezone: 'GB'),
    updated_at: Field::DateTime.with_options(timezone: 'GB')
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    email
    sign_in_count
    last_sign_in_at
    last_sign_in_ip
    deactivated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    email
    deactivated_at
    sign_in_count
    current_sign_in_at
    last_sign_in_at
    current_sign_in_ip
    last_sign_in_ip
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    email
    password
    password_confirmation
  ].freeze

  # Overwrite this method to customize how admin users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(admin_user)
    admin_user.email
  end
end
