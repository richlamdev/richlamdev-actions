import os
user_input = "test"
os.system(f"echo {user_input}")  # Command injection vulnerability
print(user_input)
