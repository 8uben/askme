module ApplicationHelper
  # Этот метод возвращает ссылку на аватарку пользователя, если она у него есть.
  # Или ссылку на дефолтную аватарку, которую положим в app/assets/images
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def incline(count, one, several, many)
    number_inclination = count % 10

    form =
      if (11..14).include?(count % 100)
        many
      elsif number_inclination == 1
        one
      elsif (2..4).include?(number_inclination)
        several
      else
        many
      end

    "#{count} #{form}"
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end
