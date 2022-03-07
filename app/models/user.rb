class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy 
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy

    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower 

    before_save { self.email = email.downcase }


    validates :first_name, presence: true, length: { maximum: 50 }
    validates :last_name, presence: true, length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 200 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: true 

    has_secure_password
    validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

    # Returns a user's status feed.
    def feed
    following_ids = "SELECT followed_id FROM relationships
    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
        OR user_id = :user_id", user_id: id)
    end
    #follow a user
    def follow(other_user)
        following << other_user
    end

    #unfollows a user
    def unfollow(other_user)
        following.delete(other_user)
    end

    #returns true if the current user is following the other user
    def following?(other_user)
        following.include?(other_user)
    end 


end
