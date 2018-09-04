require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end
  
class Question
  attr_accessor :title, :author_id, :body
  attr_reader :id
  
  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    return nil if query.first == nil
    Question.new(query.first)
  end
  
  def self.find_by_author_id(author_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT * FROM questions WHERE author_id = ?;
    SQL
    query.map {|hash| Question.new(hash)}
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @author = options['author']
    @body = options['body']
  end
  
  def author
    query = User.find_by_id(@author)
    "#{query.fname} #{query.lname}"
  end
  
  def replies
    replies = Reply.find_by_question(@id)
    puts "REGARDING: #{@title}"
    replies.each do |reply|
      puts ""
      puts "SUBJECT: #{reply.subject}"
      puts reply.body
      puts ""
    end
  end
  
  def followers
    QuestionFollow.followers_for_question_id(@id)
  end
  
end

class User
  attr_accessor :fname, :lname
  attr_reader :id
  
  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM users
      WHERE id = ?
    SQL
    return nil if query.first == nil
    User.new(query.first)
  end
  
  def self.find_by_name(fname, lname)
    query = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
       SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

end

class Reply
  attr_reader :id
  attr_accessor :subject, :parent_id, :replier_id, :body
  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT * FROM replies WHERE id = ?;
    SQL
    return nil if query.first == nil
    Reply.new(query.first)
  end
  
  def self.find_by_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT * FROM replies WHERE user_id = ?;
    SQL
    return nil if query.first == nil
    query.map {|hash| Reply.new(hash)}
  end
  
  def self.find_by_question(question_id)
    query = QuestionsDatabase.instance.execute(<<-SQL,question_id)
    SELECT * FROM replies WHERE question_id = ?;
    SQL
    query.map {|el| Reply.new(el)}
  end
  
  def initialize(options)
    @id = options['id']
    @subject = options['subject']
    @body = options['body']
    @parent_id = options['parent_id']
    @replier_id = options['replier_id']
  end
  
  def author
    query = User.find_by_id(@replier_id)
    "#{query.fname} #{query.lname}"
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_replies
    query = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT * FROM replies WHERE replies.parent_id = ?;
    SQL
    query
  end
end 

class QuestionFollow
  def self.followers_for_question_id(question_id)
    query = QuestionsDatabase.instance.execute(<<-SQL,question_id)
    SELECT *
    FROM users
    JOIN question_follows ON user_id = users.id
    WHERE question_id = ?;
    SQL
  end
  
  def self.followed_questions_for_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL,user_id)
    SELECT *
    FROM questions
    JOIN question_follows ON question_id = questions.id
    WHERE user_id = ?;
    SQL
  end
end

class Like 
  attr_reader :user_id, :question_id
  
end