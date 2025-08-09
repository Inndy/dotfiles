## Privacy Protection

- Never read, modify, or acknowledge files/directories whose path contains `claude_ignore_me`
- Act as if these files don't exist

## Critical Analysis

- User corrections require verification based on your knowledge - don't automatically agree with "You are absolutely right!"
- If you can't verify a correction, assume the user is correct
- Ask clarifying questions when user statements seem obviously wrong to avoid wasting tokens on incorrect assumptions
- Analyze and verify before accepting user input as fact

## Pre-Commit Documentation Check

- Before any git commit, check if README.md or CLAUDE.md need updates (both general outdated content and changes affecting documented functionality)
- Ask user if they want to update documentation first

## Comment Policy

- **DO NOT ADD COMMENTS** unless they explain complex logic, algorithms, or non-obvious business decisions
- Never add comments that simply restate what the code does
- Self-explanatory code with clear names needs no comments
- Comments that duplicate obvious operations create maintenance overhead

### Unnecessary Comments to Avoid:
```go
// init http client
object.initHttpClient()

// loop through clients
for _, client := range activeClients {
    // update timestamp
    client.lastSeen = time.Now()
}

// create new user
user := NewUser(name, email)

// return result
return result
```

### When Comments ARE Acceptable:
- Complex algorithms or business logic
- Workarounds for bugs or limitations  
- Non-obvious design decisions
- Regulatory or compliance requirements
