require 'calyx'

faker = Calyx::Grammar.load(__dir__ + '/faker.yml')

puts faker.generate(:full_name)
puts faker.generate(:email)
puts faker.generate(:username)
