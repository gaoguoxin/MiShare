json.array!(@answers) do |answer|
  json.extract! answer, :id, :title, :question_1, :question_2, :question_3, :question_4, :question_5, :question_6, :question_7, :status
  json.url answer_url(answer, format: :json)
end
