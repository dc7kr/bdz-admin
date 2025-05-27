class EventMealsMailer < ApplicationMailer
  def notify(meal_data, cc)
    @meal_data = meal_data
    mail(to: @meal_data.email, cc: cc, subject: t("event_meals_mailer.subject", id: @meal_data.id))
  end
end
