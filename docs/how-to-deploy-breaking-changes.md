# How to deploy breaking changes

When we deploy changes to the form it's easy to break things for users who are currently filling in the form.

For example,

- Re-arranging questions: Users might miss a question or get asked a question twice.
- Removing or renaming routes: Could make users request a page that now 404s

We need to deploy the form is such way that provides the least disruption to the user, and doesn't prevent them from submitting the form.

## Multi-stage feature development

Also known in some circles as A-AB-B deployment.

This describes a process where changes are deployed in stages.

### Changing a question

If new questions are being added, i.e. new data is being stored in FormResponse, or questions are being removed, then the first changed deployed should make these values optional:

- So in the case of a new question, these new values will be added to normal list of properties in the JSON schema.
- In the case of removed questions, these values should be removed from the "required" list in the JSON schema.
- If the options for a question is changing, the new values should be added to the enumeration.

This means that after the work to validate FormResponse against the JSON schema is added, users won't be stopped from submitting their response because the schema changed midway through their journey.

Once the first change has been deployed, a second PR should be created to either:

- Make the field required
- Disallow the field
- Remove extraneous options from the field in the JSON schema.

#### Notify other teams

If new questions have been added, or the options for a question have changed the downstream data also need to be notified about the changes.

This because changes to the fields won't get pulled through automatically and delivered to their consumers (for example Local Authorities or wholesalers), so they need to know to update their scripts.

## Programmatically determine the next question to ask the user

There is already a card in the works to implement this. The benefit of this is that users will always submit all of the data needed to make their claim as they will be directed to complete any new questions.

However this won't negate the need for multi-stage deployment as users already part way through their application when a new version is deployment should still be allowed to submit the data from any "old" questions they might have already completed.
