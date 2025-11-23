class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  enum :gender, {
    male: 1,
    female: 2,
    prefer_not_to_say: 3
  }


  validates :name, presence: true
  validates :name, length: { minimum: 3 }, allow_blank: true
  validates :biography, length: { maximum: 1000 }, allow_blank: true
  validates :birth_date, presence: true
  validates :birth_date,
    comparison: { greater_than: Date.new(1900, 1, 1), less_than: Date.today },
    allow_blank: true
  validates :death_date, comparison: { greater_than: :birth_date }, allow_blank: true
  validates :nationality, presence: true
  validates :nationality, length: { minimum: 3 }, allow_blank: true

  validates :gender, presence: true
end
