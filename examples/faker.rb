require 'calyx'

faker = Calyx::Grammar.load(__dir__ + '/faker.json')

puts faker.generate(:full_name)
puts faker.generate(:email)
puts faker.generate(:username)
