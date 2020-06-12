# Define routing between pages using config, not code 

## Summary

We have various controllers in the app that look like:

```ruby
  def next_page_url
    return dietary_requirements_url if answer_next_question?
    return check_your_answers_url if session[:check_answers_seen]

    basic_care_needs_url
  end
```

We want anyone to easily change the routing of questions, and the conditional logic that determines which questions a user sees next.
This is an important but complex part of making the apps more data driven.

## Problem

At the moment all questions are coded as a separate controller. This makes adding new questions or changing the order quite cumbersome.
Secondly, if we deploy changes to the order then current users could end up completing their journey without answering all questions.
We would like to solve these by using configuration files (which in the future could be created by a publishing app) to define the flow.  

## Proposal

It is proposed that a YAML file can be used to define the flow through the forms. A single controller would handle the pages that are defined in the YAML file.
It is proposed that an Interactor pattern is used to handle the validation (beyond the scope of this RFC) and return the next path (assuming validation passes)
 [Interactors in Ruby](https://goiabada.blog/interactors-in-ruby-easy-as-cake-simple-as-pie-33f66de2eb78)

### Simple flows
Many of the forms have a simple flow which involves checking for invalid values on the form and then progressing to the next page if no validation problems are found.
(The validation is beyond the scope of this RFC) 
An example of this would be the `name` controller which checks for validation and then proceeds to the `date_of_birth` controller. This type of progress could simply be defined in YAML as
```yaml
name:
  default_next_question: 
    question_path: date_of_birth
``` 

(`question_path` would signify the next path handled by the YAML file and `path` could be used to signify a request to a normal rails route)

An alternative could be that rather than defining the default next question, that could be worked out from the order of the questions in the YAML file? 
We already do this to determine the order that the questions are played back on the check answers page. Perhaps instead this could define the "not-happy" path?
But if people are manually copy/pasting a question to a different section of the yaml file then as the flow isn't explicit and requires a bit more thinking - possibly causing manual error.

### Simple conditionals
The next simplest definition would be around a different path being taken depending upon an answer selected and stored
For example, if the user does not live in england we direct them to `not_eligible_england` controller 
```yaml
live_in_england:
  default_next_question: 
    question_path: nhs_letter
  conditional_paths:
  - conditions:
      live_in_england:
      - 'No'
      question_path: not_eligible_england
```
Note: We should use the option key here rather than the value in the content as that is more likely to change. But it is left as a literal at the moment for simplicity of the exmaple

More complex conditionals could be combined using `and` and `or` logic, similar to [JsonLogic](http://jsonlogic.com/) but is currently
not proposed (see Custom Routing) and instead is something to consider as we further develop (YAGNI).

### Check answers seen
A further complexity for the routing is that the user may return to a page/section from the "Check Answers" page. 
Any implementation must be able to recognise this and return to the check answers page after a section is complete.
The proposal is that each path can be marked with a flag for `redirect_if_check_answers_seen: true` which will move back to the check answers page as it currently does
```yaml
nhs_letter:
  default_next_question:
    redirect_if_check_answers_seen: false
    question_path: name
...
```
As most questions will route back to the check answers page, this could be the default behaviour and only need to add `redirect_if_check_answers_seen: false` for those cases and true would be assumed for others.

### Custom routing
The most complex path routing happens when the conditional is defined using ruby statements and expressions.
The two examples of this are (i) in the `postcode_lookup` controller and (ii) `essential_supplies` controller.
At the moment it is recommended that these are marked in the YAML as "custom". When the handler (`interactor`?) encounters a `custom`
conditional, then it would look for a custom method in the app that could define the next path. 
These custom routing methods could also handle the possible circular routes, for example, repeating a path for multiple supplies in the
business support app.
Assuming that the name of the interactor matches the name of the question, a custom property may not need to be defined 
as it's possible to use the question name to determine if the interactor class exists (has been defined).

### Mandatory questions and deploying flow changes
One of the problems with the current app is that changing the flow can affect users part way through there journey.
By defining the paths in this file, along with the conditions for branching, the app should be able to check the "path journey" on each
request and ensure that the path can be traced up to the current request. Any missing questions could cause the request to be redirected to the missing question.

Logic for determining any missed question could be:
1. The controller has a list of all questions from the YAML file, that it must prune to find the next question
2. It would need to remove all answered questions (including skipped)
3. Then it would need to remove questions that don’t need to be answered based on previous answers
4. Then return the first question in that list, or if the list is empty, the check your answers page
