SUPPORTED_IMAGE_FORMATS = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/bmp"]

module Spree
  class DigitalAsset < Spree::Base
    belongs_to :folder
    has_many :assets

    has_one_attached :attachment

    before_validation :assign_default_name, on: :create

    validate :check_attachment_presence
    validate :check_attachment_content_type
    validates :name, :folder, presence: true

    scope :approved, -> { where(approved: true) }
    scope :not_approved, -> { where(approved: false) }

    def associated_products
      products = []
      assets.where(viewable_type: 'Spree::Variant').each do |asset|
        products << asset.viewable.product
      end
      products.uniq
    end

    private

      def assign_default_name
        self.name = File.basename(attachment.try(:filename).to_s, '.*').titleize.truncate(255) if name.blank?
      end

      def check_attachment_presence
        unless attachment.attached?
          attachment.purge
          errors.add(:attachment, 'Attachment must be present')
        end
      end

      def check_attachment_content_type
        if attachment.attached? && !attachment.content_type.in?(SUPPORTED_IMAGE_FORMATS)
          attachment.purge
          errors.add(:attachment, 'Content type of attachment is invalid')
        end
      end
  end
end
