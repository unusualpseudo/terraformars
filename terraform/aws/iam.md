# githubactions role iam policy

To avoid a chicken egg problem, i had to create the access policy for IAM manualy :

```shell
aws iam create-policy \
        --policy-name github-iam-access-policy \
        --policy-document file://github_iam_policy.json \
         --description "This policy grants iam access to githubactions role"

# attach the policy to the role
aws iam attach-role-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/github-iam-access-policy --role-name github-actions-role

```
