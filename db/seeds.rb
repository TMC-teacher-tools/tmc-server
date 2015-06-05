User.create!(login: 'admin', password: 'admin', administrator: true, email: 'admin@example.com', legitimate_student: false)
User.create!(login: 'test', password: 'test', administrator: false, email: 'test@example.com')

arto = User.create!(login: 'arto', password: 'arto', administrator: false, email: 'arto@example.com')
pekka = User.create!(login: 'pekka', password: 'pekka', administrator: false, email: 'pekka@example.com')
liisa = User.create!(login: 'liisa', password: 'liisa', administrator: false, email: 'liisa@example.com')
oppilas = User.create!(login: 'oppilas', password: 'oppilas', administrator: false, email: 'oppilas@example.com')

hy = Organization.create!(name: 'Helsingin yliopisto', information: 'Tosi nörteille', slug: 'hy',acceptance_pending: false, accepted_at: Time.now)
team = Organization.create!(name: 'Keravan ammattikoulu', information: 'Älä ajattele vaan tee', slug: 'team',acceptance_pending: false, accepted_at: Time.now)
hape = Organization.create!(name: 'Haagan peruskoulu', information: 'Nuorta voimaa', slug: 'hape',acceptance_pending: false, accepted_at: Time.now)
aalto = Organization.create!(name: 'Aalto yliopisto', information: 'Insinöörin tarkuudella', slug: 'aalto',acceptance_pending: false, accepted_at: Time.now)

Teachership.create!(user_id: arto.id, organization_id: hy.id)
Teachership.create!(user_id: pekka.id, organization_id: team.id)
Teachership.create!(user_id: liisa.id, organization_id: hape.id)
Teachership.create!(user_id: pekka.id, organization_id: aalto.id)

#CourseTemplate.create!(name: 'test', title: 'Test course', description: 'Java language',
#                       source_url:'https://github.com/testmycode/tmc-testcourse.git')

CourseTemplate.create!(name: 'ohpe', title: 'Ohjelmoinnin perusteet', description: 'Peruskurssi javalla',
                        material_url: 'http://www.cs.helsinki.fi/group/java/k15',
                        source_url:'http://www.cs.helsinki.fi/group/java/repositories/tmc-kurssit/k2015.git')

Course.create!(name: 'ohpe-k2015', source_backend: 'git', git_branch: 'master',
               source_url: 'http://www.cs.helsinki.fi/group/java/repositories/tmc-kurssit/k2015.git',
               organization_id: hy.id)

Course.create!(name: 'weso-k2015', source_backend: 'git', git_branch: 'master',
               source_url: 'https://github.com/web-selainohjelmointi/WesoTehtavat2015',
               organization_id: hy.id)

Course.create!(name: 'perusjava', source_backend: 'git', git_branch: 'master',
               source_url: 'http://www.cs.helsinki.fi/group/java/repositories/tmc-kurssit/k2015.git',
               organization_id: team.id)

cee = Course.create!(name: 'cee-k2015', source_backend: 'git', git_branch: 'master',
               source_url: 'http://www.cs.helsinki.fi/group/nodes/tmc-kurssit/c-ohjelmointi.git',
               organization_id: hy.id)

test = Course.create!(name: 'test-2014', source_backend: 'git', git_branch: 'master',
               source_url: 'https://github.com/testmycode/tmc-testcourse.git',
               organization_id: hy.id)

t = Time.now
cee.refresh
puts "-- refresh time for course #{cee.name} is #{Time.now - t} seconds"

t = Time.now
test.refresh
puts "-- refresh time for course #{test.name} is #{Time.now - t} seconds"

ex1 = Exercise.all.first

puts ex1.name

Submission.create!(user: oppilas, course: cee, exercise: ex1)