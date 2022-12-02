class ErrorSerializer
  attr_reader :status,
              :title,
              :detail

  def initialize(status, title, detail)
    @status = status
    @title = title
    @detail = detail
  end

  def serialized_message
    {
      errors: [
        {
          status: @status,
          title: @title,
          detail: @detail
        }
      ]
    }
  end
end