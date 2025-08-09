Commit changes using git with following rules:

1. **Commit Strategy**: Always commit changes using git commit with meaningful, descriptive commit messages.

2. **Separate Logical Changes**: Divide changes into separate commits when they represent distinct, meaningful actions or features. Each commit should represent a single logical unit of work.

3. **Commit Ordering**: When creating multiple commits, carefully consider the dependency chain between changes. Commit changes in the correct order to ensure:
   - Each commit builds successfully on the previous one
   - Dependent changes are committed after their prerequisites
   - The repository remains in a functional state after each commit

4. **Seek Clarification**: If you cannot resolve the dependency of changes or cannot ensure a single commit will work (compile or execute without errors), ask the user for guidance on how to group the changes.

5. **Commit Message Format**: Use clear, concise commit messages that describe what the change accomplishes (e.g., "Add user authentication middleware" rather than "Update files").

6. **Testing Reminder**: Once per conversation, when first asked to commit changes, suggest running tests between commits to verify the repository remains stable. If the user requires tests, run them before each git commit. The goal is to ensure every single commit works and can function independently.
