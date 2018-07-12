# twitter-demo

This is a simple webapp that allows you to search for tweets. It is a backend exercise; the frontend could be prettier.

## To Run:
This is a Rails 5.2 app, that means the credentials are stored in the new encrypted rails credentials file. (If you're unfamiliar with these new changes, check out http://guides.rubyonrails.org/security.html#custom-credentials or https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2) 

To get this app to run, you have two options:
  - Delete the encrypted `credentials.yml.enc` and create your own using the structure referenced below.
  - Ask for my master key to decrypt and use the existing credentials.
  
 ```
credentials.yml
twitter:
  CONSUMER_KEY: YOUR_KEY_HERE
  CONSUMER_SECRET: YOUR_KEY_HERE
