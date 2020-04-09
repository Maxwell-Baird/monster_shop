class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular
    select('items.*, SUM(quantity) as total_quantity').joins(:item_orders).group('items.id').order('total_quantity DESC').limit(5)
  end

  def self.least_popular
    select('items.*, SUM(quantity) as total_quantity').joins(:item_orders).group('items.id').order('total_quantity').limit(5)
  end
end
