class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  enum :gender, {
    male: 1,
    female: 2,
    prefer_not_to_say: 3
  }

  after_initialize :initialize_metadata

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 255 }, allow_blank: true
  validates :biography, length: { maximum: 1000 }, allow_blank: true
  validates :birth_date, presence: true
  validates :birth_date,
    comparison: { greater_than: Date.new(1900, 1, 1), less_than: Date.today },
    allow_blank: true
  validates :death_date, comparison: { greater_than: :birth_date }, allow_blank: true
  validates :nationality, presence: true
  validates :nationality, length: { minimum: 3 }, allow_blank: true

  validates :gender, presence: true

  # Metadata validations
  validate :validate_metadata_website, if: -> { metadata.present? && metadata["website"].present? }
  validate :validate_metadata_email, if: -> { metadata.present? && metadata["email"].present? }
  validate :validate_metadata_twitter, if: -> { metadata.present? && metadata["twitter"].present? }
  validate :validate_metadata_facebook, if: -> { metadata.present? && metadata["facebook"].present? }
  validate :validate_metadata_tags, if: -> { metadata.present? && metadata["tags"].present? }
  validate :validate_metadata_notes, if: -> { metadata.present? && metadata["notes"].present? }

  private

  def initialize_metadata
    self.metadata ||= {}
  end

  def validate_metadata_website
    website = metadata["website"]
    return if website.blank?

    uri = URI.parse(website)
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:metadata, "website must be a valid URL (starting with http:// or https://)")
    end
  rescue URI::InvalidURIError
    errors.add(:metadata, "website must be a valid URL")
  end

  def validate_metadata_email
    email = metadata["email"]
    return if email.blank?

    unless email.match?(URI::MailTo::EMAIL_REGEXP)
      errors.add(:metadata, "email must be a valid email address")
    end
  end

  def validate_metadata_twitter
    twitter = metadata["twitter"]
    return if twitter.blank?

    # Allow Twitter username (with or without @) or Twitter URL
    twitter_username_pattern = /\A@?[A-Za-z0-9_]{1,15}\z/
    twitter_url_pattern = %r{\Ahttps?://(www\.)?(twitter\.com|x\.com)/[A-Za-z0-9_]{1,15}\z}

    unless twitter.match?(twitter_username_pattern) || twitter.match?(twitter_url_pattern)
      errors.add(:metadata, "twitter must be a valid username (e.g., @username) or Twitter URL")
    end
  end

  def validate_metadata_facebook
    facebook = metadata["facebook"]
    return if facebook.blank?

    facebook_pattern = %r{\Ahttps?://(www\.)?(facebook\.com|fb\.com)/.+\z}
    unless facebook.match?(facebook_pattern)
      errors.add(:metadata, "facebook must be a valid Facebook URL")
    end
  rescue StandardError
    errors.add(:metadata, "facebook must be a valid URL")
  end

  def validate_metadata_tags
    tags = metadata["tags"]
    return if tags.blank?

    # Convert to array if it's a string
    tag_array = tags.is_a?(Array) ? tags : tags.to_s.split(",").map(&:strip)

    if tag_array.length > 20
      errors.add(:metadata, "tags cannot exceed 20 tags")
    end

    tag_array.each do |tag|
      tag_str = tag.to_s.strip
      if tag_str.length > 50
        errors.add(:metadata, "each tag cannot exceed 50 characters")
      end
    end
  end

  def validate_metadata_notes
    notes = metadata["notes"]
    return if notes.blank?

    if notes.length > 2000
      errors.add(:metadata, "notes cannot exceed 2000 characters")
    end
  end
end
