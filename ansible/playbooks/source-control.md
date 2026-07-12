# SOURCE CONTROL: TEST CASES

## CLONE

### TAG: clone

- Remote branch is cloned into working directory using the same name as the repo, e.g. root created
- Remote is cloned into existing directory at the root. Make directory if not there.
  
## BRANCH
  - TAG: make_branch
  - Remote branch does not exist, create local branch
  - Remote branch exists, switch to local branch 
  
## DO WORK

## STAGE FILES  

### TAG: switch_stage

1. Finds the repo worktree path.
2. Checks whether the target branch exists on remote.
3. Switches to that branch (or creates a local branch if remote one does not exist).
4. Runs git add with your configured files_to_stage value.

student@bchd:~/test/foo$ git status
On branch feat/test
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   THIS_IS_A_TEST_FILE

## COMMIT 

### TAG: commit

In your playbook, the commit tag does this:

Ensures you are on the target branch (it includes the branch check/switch logic).
Checks whether anything is staged with git diff --cached --quiet.
Builds a commit message:
Uses commit_message if set.
Otherwise prompts you interactively.
Validates the message is not empty.
Creates a git commit only when staged changes exist.
It does not run git add and it does not push to remote.


student@bchd:~/test/foo$ git status
On branch feat/test
Your branch is ahead of 'origin/feat/test' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
student@bchd:~/test/foo$ 


## PUSH 

### TAG: push

- Look for the message that is "up to date" 
  
student@bchd:~/test/foo$ git status
On branch feat/test
Your branch is up to date with 'origin/feat/test'.

nothing to commit, working tree clean
student@bchd:~/test/foo$ 

## DO IT ALL AT ONCE

- Sample command

```bash
ansible-playbook source_control.yaml --tags switch_stage,commit,push -e "branch_name=your-branch"
```