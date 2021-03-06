class Event < ActiveRecord::Base
  include Fae::BaseModelConcern
  include GeocodedAddress

  has_many :user_events
  has_many :users, class_name: 'Fae::User',
    through: :user_events

  has_one :hero_image, -> { where(attached_as: 'hero_image') },
    as: :imageable,
    class_name: '::Fae::Image',
    dependent: :destroy
  accepts_nested_attributes_for :hero_image, allow_destroy: true

  validates :venue_name, :address_1, :city, :state, :tradition, :capacity, presence: true

  VALID_ADDRESS_REGEX = /^[\w\s-]*$/u

  validates :address_1, presence: true, format: { with: VALID_ADDRESS_REGEX, multiline: true }

  validates :title, length: { maximum: 100 }, presence: true

  validates :introduction, length: { maximum: 250 }, presence: true

  validates :description, length: { maximum: 300 }, presence: true

  validates :preparation, :instructions, :restrictions, :code_of_conduct, :comments, length: { maximum: 500 }

  validates :zip, format: { with: /^\d{5}$/, multiline: true, message: "Please format correctly e.g. 01234" }, presence: true

  validates :slug,
    uniqueness: true,
    format: {
      with: Fae.validation_helpers.slug_regex,
      message: "no spaces or special characters",
      multiline: true
    }, presence: true

  def fae_display_field
    title
  end

  def has_users_and_user(user)
    users.present? && users.include?(user)
  end

  class << self

    def event_filter(params)

      conditions = {}

      conditions[:venue_name] = params[:venue_name] if params[:venue_name].present?

      order(:venue_name).where(conditions)

    end

  end

end
