$stdout.sync = true
start = Time.now

# -- Users --

puts ''
puts 'Create users...'

def create_user(name, admin = false)
  User.create!(login: name.downcase, password: name.downcase, administrator: admin, email: "#{name.downcase}@example.com")
end

def students
  User.all.reject { |u| u.login =~ /^(admin|test|ope\d+|asse\d+)$/ }
end

student_names = %w(Matti Timo Juha Kari Mikko Antti Jari Jukka Markku Pekka Mika Hannu Heikki Seppo Ari Janne Sami Erkki
Ville Pentti Marko Petri Lauri Jani Jorma Raimo Harri Eero Teemu Risto Jaakko Jarmo Martti Pertti Pasi Jussi Veikko Esa
Reijo Jouni Juho Arto Toni Esko Jouko Niko Vesa Markus Olli Tomi Tuomas Kimmo Joni Aleksi Tommi Tero Joonas Henri Paavo
Pauli Ilkka Kalle Jarkko Eetu Eino Tuomo Jesse Leo Tapio Veli Joona Keijo Jere Simo Juuso Lasse Jyrki Mikael Kauko Juhani
Toivo Arttu Matias Mauri Onni Reino Elias Aki Kai Riku Väinö Teuvo Rauno Jarno Miika Leevi Otto Tauno Jan Tuula Ritva
Anna Anne Päivi Leena Pirjo Marja Sari Minna Riitta Tiina Pirkko Tarja Eeva Anja Liisa Laura Eila Aino Seija Raija Sirpa
Jaana Satu Hanna Heidi Sanna Eija Maria Merja Kirsi Arja Maija Sirkka Johanna Ulla Paula Jenni Terttu Raili Hilkka Elina
Katja Kirsti Heli Mari Nina Anni Mirja Kaija Helena Anu Tuija Emma Irma Niina Kaisa Aila Irja Saara Leila Pia Suvi Katri
Sara Tanja Lea Jenna Maarit Marjo Kati Kerttu Henna Emilia Noora Ella Marja-Leena Sinikka Susanna Riikka Veera Taina
Outi Mervi Julia Iida Aune Sofia Virpi Helmi Jonna Marja-Liisa Milla Miia Emmi Sonja Tiia Sisko).shuffle

student_names.each { |name| create_user(name) }

teacher_names = []
20.times { |i| teacher_names << "ope#{i}" }

teachers = []
teacher_names.each do |name|
  teachers << create_user(name)
end

assistant_names = []
20.times { |i| assistant_names << "asse#{i}" }

assistants = []
assistant_names.each do |name|
  assistants << create_user(name)
end

# -- Organizations --

puts 'Create organizations...'

def create_organization(name, slug, pending = false)
  Organization.create!(name: name, slug: slug, acceptance_pending: pending)
end

org_names = [['Helsingin yliopisto', 'hy'],
             ['Aalto-yliopisto', 'aalto'],
             ['Haaga-Helia', 'hahe'],
             ['Itä-Suomen yliopisto', 'itsy'],
             ['Jyväskylän yliopisto', 'jyy'],
             ['Tampereen yliopisto', 'tamy'],
             ['Åbo Akademi', 'akademi'],
             ['Lapin yliopisto', 'ly'],
             ['Lappeenrannan teknillinen yliopisto', 'ltk'],
             ['Oulun yliopisto', 'oy'],
             ['Maanpuolustuskorkeakoulu', 'mpkk'],
             ['Tampereen teknillinen yliopisto', 'tty'],
             ['Turun yliopisto', 'tury']]

org_names.each { |pair| create_organization(pair[0], pair[1]) }

# -- Teacherships --

puts 'Create teacherships...'

def create_teachership(slug, login)
  Teachership.create!(organization: Organization.find_by(slug: slug), user: User.find_by(login: login))
end

teacherships = {
    hy: [1, 2, 3, 4, 5],
    aalto: [3, 4, 5, 6],
    hahe: [5, 6, 7],
    akademi: [8, 9]
}

teacherships.each do |k, v|
  v.each do |i|
    create_teachership(k, "ope#{i}")
  end
end

# -- Course templates --

puts 'Create course templates...'

def create_course_template(name, title, description, material, source, expires = nil)
  CourseTemplate.create!(name: name, title: title, description: description, material_url: material, source_url: source, expires_at: expires)
end

create_course_template('test-course', 'Test course', 'For testing purposes', nil, 'https://github.com/testmycode/tmc-testcourse.git')
create_course_template('programming-in-c', 'Programming in C', 'Introduction to C programming', nil, 'https://github.com/testmycode/tmc-testcourse.git')
create_course_template('web-selainohjelmointi', 'Web-selainohjelmointi', nil, 'https://web-selainohjelmointi.github.io/', 'https://github.com/web-selainohjelmointi/WesoTehtavat2015.git')

# -- Courses --

puts 'Create courses...'

def create_course(name, params, organization, count = 0)
  _name = name
  _name = "#{name}-#{count}" unless count == 0
  unless Course.exists?(name: _name)
    Course.create!({ name: _name }.merge(params).merge(organization: organization))
  else
    create_course(name, params, organization, count + 1)
  end
end

courses = {
    ohpe: {
        source_url: 'http://www.cs.helsinki.fi/group/java/repositories/tmc-kurssit/k2015.git',
        title: 'Ohjelmoinnin perusteet'
    },
    weso: {
        source_url: 'https://github.com/web-selainohjelmointi/WesoTehtavat2015.git',
        title: 'Web-selainohjelmointi'
    },
    cee: {
        source_url: 'http://www.cs.helsinki.fi/group/nodes/tmc-kurssit/c-ohjelmointi.git',
        title: 'C-ohjelmointi'
    },
    testcourse: {
        source_url: 'https://github.com/testmycode/tmc-testcourse.git',
        title: 'Test course'
    }
}

org = Organization.find_by(slug: 'hy')
create_course(:ohpe, courses[:ohpe].merge(title: 'Ohjelmoinnin perusteet s2014'), org)
create_course(:weso, courses[:weso], org)
create_course(:cee, courses[:cee].merge(title: 'C-ohjelmointi s2014'), org)
create_course(:cee, courses[:cee].merge(title: 'C-ohjelmointi k2015'), org)
create_course(:testcourse, courses[:testcourse], org)
create_course(:testcourse, courses[:testcourse].merge(title: 'Test course 2'), org)

org = Organization.find_by(slug: 'aalto')
create_course(:ohpe, courses[:ohpe].merge(title: 'OhPe s14'), org)
create_course(:ohpe, courses[:ohpe].merge(title: 'OhPe k15'), org)
create_course(:weso, courses[:weso], org)
create_course(:cee, courses[:cee].merge(title: 'Cee s14'), org)
create_course(:cee, courses[:cee].merge(title: 'Cee k15'), org)
create_course(:testcourse, courses[:testcourse], org)
create_course(:testcourse, courses[:testcourse].merge(title: 'Test course 2'), org)

# -- Refresh courses --

puts 'Refresh courses...'

Organization.find_by(slug: 'hy').courses.each do |course|
  puts " -> #{course.title}"
  course.refresh
end

# -- Assistantships --

puts 'Create assistantships...'

def create_assistantship(slug, nth_course, login)
  org_id = Organization.find_by(slug: slug).id
  course = Course.where(organization_id: org_id).order('id')[nth_course]
  Assistantship.create!(course: course, user: User.find_by(login: login))
end

assistantships = {
    hy: {
        0 => [1, 2, 3],
        1 => [2, 3, 4, 5],
        2 => [1, 2, 5],
        3 => [7, 8],
        4 => [2, 4, 6]
    },
    aalto: {
        0 => [10, 14, 17],
        1 => [10, 12, 11],
        2 => [16, 15, 19],
        3 => [11]
    }
}

assistantships.each do |k, v|
  v.each do |n, arr|
    arr.each do |i|
      create_assistantship(k, n, "asse#{i}")
    end
  end
end

# -- Submissions --

puts 'Create submissions...'

def award_points(user, exercise, submission)
  points = []
  AvailablePoint.where(exercise: exercise).each do |point|
    point.award_to(user, submission)
    points << point.name
  end
  submission.update(points: points.join(' '))
end

def create_submission(user, exercise, processed = true, passed = true)
  s = Submission.create!(user: user, exercise: exercise, course: exercise.course, processed: processed, all_tests_passed: passed)
  FactoryGirl.create :submission_data, submission: s
  award_points(user, exercise, s) if processed && passed
end

def add_random_submissions_to_course(course, participant_count)
  exercises = course.exercises
  participants = students.sample(participant_count)

  participants.each_with_index do |student, i|
    print "\r -> #{course.title}: #{i + 1}/#{participants.length}"

    completed = rand(0..exercises.length)
    exercises[0..completed].each do |ex|
      failed = rand(0..100) >= 80
      create_submission(student, ex, true, !failed)
    end
  end

  puts ''
end

Course.all.each do |course|
  add_random_submissions_to_course(course, rand(15..40)) unless course.refreshed_at.nil?
end

# -- Code reviews --

puts 'Create code reviews...'

def review_submission(submission)
  reviewer = submission.course.organization.teachers.sample
  Review.create!(submission: submission, reviewer: reviewer, review_body: 'Ok.')
  submission.reviewed = true
  submission.review_dismissed = false
  submission.save!()
end

all_submissions = Submission.all
request_submissions = all_submissions.sample(all_submissions.length / 9)

request_submissions.each do |sub|
  sub.update(requests_review: true)
end

request_submissions.sample(request_submissions.length / 3).each do |sub|
  review_submission(sub)
end

# -- Feedback questions & answers --

puts 'Create feedback...'

Course.all.each do |course|
  FeedbackQuestion.create!(course: course, question: 'Difficulty?', title: 'Difficulty?', kind: 'intrange[0..5]')
  FeedbackQuestion.create!(course: course, question: 'Opinions?', title: 'Opinions?', kind: 'text')
end

Submission.all.each do |sub|
  next if rand(0..100) >= 40
  exercise = sub.exercise
  questions = FeedbackQuestion.where(course: exercise.course)
  questions.each do |question|
    if question.kind == 'text'
      answer = ['Easy', 'Hard', 'Very difficult', 'Boring', 'Fun', 'Ok'].sample
    else
      answer = rand(0..5).to_s
    end
    FeedbackAnswer.create!(feedback_question: question, course: exercise.course, exercise_name: exercise.name, submission: sub, answer: answer)
  end
end

puts "Completed in #{Time.now - start} seconds."
