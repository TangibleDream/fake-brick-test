# Fake brick test
This is a series of tests made for a fake gold brick puzzle made by Fetch Rewards.  Word has it that the lead is a fan of Ruby, which I cut my teeth on, and also like alot. So here it is.

## Bug
One bug I found was the weighting result square is set as an inactive button labeled #reset, which is double labeled with the actual #reset button at the top.  I purposefully left the code garish in that instance in anticipation of a bug fix.

## System

I am running this on my MacBook Pro (16-inch,2019) 2.3GHz 8-Core Intel Core i9, Memory 16 GB 2667 MHz DDR4

You should also have 

- Ruby Version 3.0.0
- RVM Version 1.29.12
- Chromedriver Version 88.04389.23 *
- Chrome Version 88.0.4324.150 (Official Build) (x86_64) 
or whatever chromedriver/chrome combo works for you

Anything else you should be able to get from the Gemfile

## Installation

In addition to istalling bundler and doing bundle installs  I specifically needed to install the rspec and capybara gem, odd, but there it is.

You can nab a chromedriver build at `https://chromedriver.storage.googleapis.com/index.html`

place it in your path.  On a mac you can find that by running

`echo $PATH`

after that you should be good to do the rest.

If all is well you should be able to kick things off by cloning the repo to your local machine. 

`git clone git@github.com:TangibleDream/fake-brick-test.git`

`cd fake-brick-test`

`gem install bundler`

`bundle install`

If all is well running `rspec` should kick off the tests. If it acts like something is not installed, you may wish to install them individually.

you can see what you have up by typing

`gem list`

if, for example, rspec disappeared, you can add it again by typing

`gem install rspec`

## Test Cases

I have worked with Cucumber and Specflow when I was at Innerworkings, lately I've been running mohca on Webdriver.io which has the describe/it lingo that rspec shares.

- I created two tests for working the puzzle: a median quick sort that can solve in 1 weighing if the fake brick happens to be 8, or 3 weighings.  8 to 4,  4 to 2, and 2 to 1.
  That was very conditional, and I thought a simpler algorithm like 1 to 8 compared to 0 would take less processing and would be quicker on average.  I was right, but barely. It would fall behind the median split sort if there were 20 bricks to sort through.

- For the weigh button test I wanted to make sure the Result (erroneously named reset) button had one of the 3 comparitave operators present.  I was unable to find a logical or paired with the expect page function, so I fashoned my own.

- I was able to get by mostly with ID element calls, but you'll also find css and xpath in there, nothing too fancy.

## Thanks, and more things to look at

This was fun, thanks for sending this my way.

For more code done by me,  I would reccomend checking out a chess app I did in Javascript. If you do not know how to play, it will teach you.

`https://github.com/TangibleDream/chessJS`

For more test code, here is a gist of protractor selenium for my chess app.  It caught a problem I had with stalemate, and pawn promotion.  If you try it out, be sure to point line 4 of the conf.js to the correct server address you create for it.

`https://gist.github.com/TangibleDream/06ccc8db7024dc76d193bc043f2c88ed`

Thanks again, I hope to talk to you soon.
