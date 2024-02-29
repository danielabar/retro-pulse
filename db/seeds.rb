require "faker"

# Create Retrospectives
retrospective = Retrospective.create(title: "Quantum Canvas Sprint 3", status: :open)

# Create Comments for the Retrospective
Comment.create(
  content: "Maintaining end-to-end tests has been effective in catching bugs early. " \
           "Let's keep prioritizing this practice for robust and efficient development.",
  anonymous: false,
  retrospective:,
  category: :keep,
  slack_user_id: Faker::Alphanumeric.alphanumeric(number: 6),
  slack_username: Faker::Internet.username
)

Comment.create(
  content: "Kudos to the team for successfully implementing the new feature toggle system " \
           "this sprint! It's been a game-changer in terms of flexibility and risk mitigation. " \
           "Having the ability to toggle features on and off easily has not only allowed us to " \
           "ship features more confidently but has also minimized the impact of potential bugs.",
  anonymous: true,
  retrospective:,
  category: :keep
)
