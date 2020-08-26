user = User.create(name: "Test Testerson", email: "test@example.com", password: "password")

5.times do |i|
  user.posts.create(
    title: "Post #{i}",
    body: "This number #{i} of Test Testerson's really great posts"
  )
end
