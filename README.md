# Tendable Coding Assessment

## Usage

```sh
bundle
ruby questionnaire.rb
```

## Goal

The goal is to implement a survey where a user should be able to answer a series of Yes/No questions. After each run, a rating is calculated to let them know how they did. Another rating is also calculated to provide an overall score for all runs.

## Requirements

Possible question answers are: "Yes", "No", "Y", or "N" case insensitively to answer each question prompt.

The answers will need to be **persisted** so they can be used in calculations for subsequent runs >> it is proposed you use the pstore for this, already included in the Gemfile

After _each_ run the program should calculate and print a rating. The calculation for the rating is: `100 * number of yes answers / number of questions`.

The program should also print an average rating for all runs.

The questions can be found in questionnaire.rb

Ensure we can run your exercise

## Explanation of implementation

**Conducting Surveys:**

- The do_prompt method initiates the survey process by iterating through each question in the QUESTIONS hash.
- For each question, it prompts the user with the question text and records their response.
- Responses are stored in a persistent data store using the PStore library.

**Recording Responses:**

- The `record_response` method is responsible for recording user responses.
- It receives the question key, the user's answer, and the store instance.
- Within a transaction, it adds the user's response to the appropriate question key in the store.

**Calculating Ratings:**

- After all questions are answered, the calculate_ratings method calculates the rating for the current survey run.
- It counts the number of "Yes" responses and computes the percentage of "Yes" responses out of the total number of questions.
- Additionally, it calculates the average rating over all survey runs.

**Generating Reports:**

- The `do_report` method provides a summary report of survey data.
- It checks if survey data is available in the store. If not, it displays a message indicating no data is available.
- If data is available, it retrieves the total number of survey runs and calculates the average rating over all runs.
- The report is displayed to the user.