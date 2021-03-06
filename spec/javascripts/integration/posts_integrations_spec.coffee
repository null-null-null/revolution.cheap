module "posts integration"

test "posts index page", ->
  visit "/"
  andThen ->
    posts_length = find(".post-list li.post-list__item").length
    expected_result = 2
    equal posts_length, expected_result, "Expected posts to contain #{ expected_result } items, got: #{ posts_length }"

test "posts index page shows tag posts", ->
  visit "/"
  andThen ->
    tags_length = find(".tag-list:first li.tag-list__item").length
    expected_result = 2
    equal tags_length, expected_result, "Expected tags to contain #{ expected_result } items, got: #{ tags_length }"

test "Visiting a post via the index screen", ->
  visit("/").click "ul.post-list li:first a.post-list__link"
  andThen ->
    post = find("h1:last").text()
    expected_result = "Post 2"
    equal post, expected_result, "Expected: #{ expected_result }, got: #{ post }"

test "renders post", ->
  visit "/posts/post_1"
  andThen ->
    post = find("h1:last").text()
    expected_result = "Post 1"
    equal post, expected_result, "Expected: #{ expected_result }, got: #{ post }"

test "renders edit button if currentUser is owner", ->
  login()
  andThen ->
    visit "/posts/post_1"
    andThen ->
      edit_length = find(".edit-button").length
      ok edit_length >= 1, "Edit button not found"

test "does not render edit button if currentUser has not owner", ->
  login()
  andThen ->
    visit "/posts/post_2"
    andThen ->
      edit_length = find(".edit-button").length
      ok edit_length <= 1, "Edit button present in the main view"

test "redirects if user does not have edit privileges", ->
  visit "/posts/post_2/edit"
  andThen ->
    header_text = find("h1").text()
    expected_result = "Login"
    equal header_text, expected_result, "Expected: #{ expected_result }, got: #{ header_text }"

test "click edit button to go to post edit page", ->
  logout()
  andThen ->
    login()
    andThen ->
      visit "/posts/post_1/edit"
      andThen ->
        click ".edit-button"
        andThen ->
          input_fields = find(".form-fields li").length
          ok input_fields >= 1, "Input field not found"

test "saving edits persists the changes to the post then redirects to post page", ->
  login()
  andThen ->
    visit "/posts/post_1/edit"
    andThen ->
      fillIn "input[name='title']", "Valid Post"
      click "#submit_button"
      andThen ->
        header_text = find("h1:last").text()
        expected_result = "Valid Post"
        equal header_text, expected_result, "Expected: #{ expected_result }, got: #{ header_text }"

test "Show input for new post", ->
  login()
  andThen ->
    visit("/posts/new")
    andThen ->
      input_fields = find(".form-fields li").length
      ok input_fields >= 1, "Input field not found"

test "Adding a new post", ->
  login()
  andThen ->
    visit("/posts/new")
    fillIn "input[name='title']", "Valid Post"
    click "#submit_button"
    andThen ->
      header_text = find("h1:last").text()
      expected_result = "Valid Post"
      equal header_text, expected_result, "Expected: #{ expected_result }, got: #{ header_text }"

test "Adding a new post with invalid attributes", ->
  login()
  andThen ->
    visit("/posts/new")
    fillIn "input[name='title']", "Invalid Post"
    click "#submit_button"
    andThen ->
      error_text = find(".error-block li").text()
      expected_result = "is invalid"
      equal error_text, expected_result, "Expected: #{ expected_result }, got: #{ error_text }"