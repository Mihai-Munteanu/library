class Avo::Resources::Book < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :isbn, as: :text
    field :description, as: :textarea
    field :publication_date, as: :date
    field :copies_sold, as: :number
    field :price, as: :number
    field :pages, as: :number
    field :cover, as: :file
    field :author, as: :belongs_to
    field :loans, as: :has_many
  end
end
