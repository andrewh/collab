@description Review and address PR comments.
@arguments $PR: PR number to review

## 1. Fetch the PR and comments

Use `gh api repos/{owner}/{repo}/pulls/$PR` to get the PR description and status. Use `gh api repos/{owner}/{repo}/pulls/$PR/comments` to get all review comments. Also check `gh api repos/{owner}/{repo}/pulls/$PR/reviews` for review-level comments. Avoid `gh pr view` as it hits a GraphQL Projects Classic deprecation error.

## 2. Summarise comments

Group comments by type:
- **Blocking**: Changes requested that must be addressed before merge
- **Suggestions**: Non-blocking improvements worth considering
- **Questions**: Need a response but not necessarily a code change
- **Informational**: Acknowledgements, approvals, discussion

For each comment, note the file, line, author, and what they're asking for.

## 3. Check out the branch

Check out the PR branch locally. Make sure it's up to date with the remote.

## 4. Address each comment

For each blocking comment and suggestion:
- Read the relevant code in context
- Determine if the comment is valid
- If valid: make the fix
- If disagreed: draft a response explaining why

For questions: draft responses.

## 5. Verify

Run the project's test suite. Run linters. Confirm everything passes.

## 6. Commit and respond

Commit fixes as a separate commit (do not squash into previous commits). Push the branch.

Then for each comment, draft a brief response:
- If fixed: "Fixed in [commit]" with a brief note on what changed
- If disagreed: explain the reasoning clearly and respectfully
- If question: answer directly

Present all draft responses for review before posting them.
