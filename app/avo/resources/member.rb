class Avo::Resources::Member < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :email, as: :text
    field :birth_date, as: :date
    field :gender, as: :select, options: Member.genders.keys.map { |g| [g.humanize, g] }
    field :is_active, as: :boolean
    field :is_vip, as: :boolean
    field :is_admin, as: :boolean
    field :balance, as: :number
    field :total_spent, as: :number
    field :discount_rate, as: :number
    field :points, as: :number
    field :books_borrowed, as: :number
    field :books_returned, as: :number
  end
end
