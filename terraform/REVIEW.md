# Terrafrom security review

## Risks found

1. Buscket was publicly readable via allUsers.
2. Uniform bucket-level access was disabled.
3. Replaced broad IAM with least-privilege access.
4. Set force_destroy to false
5. Added ownership labels.

## Remaining questions
1. what data classification applies to this bucket
2. Does the app need read-only or read/write access?
3. Should production have deletion protection or retenstion policies?
