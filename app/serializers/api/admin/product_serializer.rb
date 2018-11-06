class Api::Admin::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :sku, :variant_unit, :variant_unit_scale, :variant_unit_name, :on_demand, :inherits_properties

  attributes :on_hand, :price, :available_on, :permalink_live, :tax_category_id, :import_date, :image_url, :thumb_url

  has_one :supplier, key: :producer_id, embed: :id
  has_one :primary_taxon, key: :category_id, embed: :id
  has_many :variants, key: :variants, serializer: Api::Admin::VariantSerializer
  has_one :master, serializer: Api::Admin::VariantSerializer

  def image_url
    if object.images.present?
      object.images.first.attachment.url(:product)
    else
      "/assets/noimage/product.png"
    end
  end

  def thumb_url
    if object.images.present?
      object.images.first.attachment.url(:mini)
    else
      "/assets/noimage/mini.png"
    end
  end

  def on_hand
    object.on_hand.nil? ? 0 : object.on_hand.to_f.finite? ? object.on_hand : I18n.t(:on_demand)
  end

  def price
    object.price.nil? ? '0.0' : object.price
  end

  def available_on
    object.available_on.blank? ? "" : object.available_on.strftime("%F %T")
  end

  def permalink_live
    object.permalink
  end
end
