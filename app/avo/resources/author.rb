class Avo::Resources::Author < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :biography, as: :textarea
    field :birth_date, as: :date
    field :death_date, as: :date
    field :nationality, as: :text
    field :gender, as: :select, options: Author.genders.keys.map { |g| [g.humanize, g] }
    field :metadata, as: :json
    field :books, as: :has_many
  end
end
