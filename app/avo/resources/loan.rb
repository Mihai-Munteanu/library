class Avo::Resources::Loan < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :member, as: :belongs_to
    field :book, as: :belongs_to
    field :start_date, as: :date
    field :due_date, as: :date
    field :return_date, as: :date
    field :status, as: :select, options: Loan.statuses.keys.map { |s| [s.humanize, s] }
    field :notes, as: :textarea
    field :metadata, as: :json
    field :created_at, as: :date
    field :updated_at, as: :date
  end
end
