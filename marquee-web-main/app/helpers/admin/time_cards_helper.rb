module Admin::TimeCardsHelper
  def get_time_card_class(time_card)
    if time_card.time_approved >= 40
      "timecard-green"
    else
      "timecard-red"
    end
  end
end
