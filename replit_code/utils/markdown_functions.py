import re


def format_to_markdown(text):
  """
    Converts given text to Markdown by identifying patterns and formatting them.
    This function:
    - Makes '**text**' bold.
    - Makes '*text*' italic before colons.
    - Converts items starting with a '*' into bullet points.
    - Processes 'Architecture generated:' specially to ensure the following text appears as a section header.
    """
  # Convert '**text**' to bold
  bold_pattern = re.compile(r'\*\*(.*?)\*\*')
  text = bold_pattern.sub(r'**\1**', text)

  # Convert words immediately before ':' to italics
  italic_pattern = re.compile(r'(\b\w[\w\s]+\b)(:)', re.IGNORECASE)
  text = italic_pattern.sub(r'*\1*\2', text)

  # Handle lines starting with a single '*' to bullet points
  lines = text.split('\n')
  new_lines = []
  skip_next = False
  for i, line in enumerate(lines):
    if skip_next:
      new_lines.append('# ' + line.strip())
      skip_next = False
      continue
    line = line.strip()
    if line.startswith('*') and line.count('*') == 1:
      new_lines.append('- ' + line[1:].strip())
    elif line.startswith('Architecture generated:'):
      new_lines.append(line + '\n')  # Add the newline for better separation
      skip_next = True
    else:
      # This part is for formatting standalone titles as headers throughout the text
      if re.match(
          r"^[A-Za-z\s]+$",
          line):  # Simple pattern to detect lines that look like titles
        new_lines.append('# ' + line)
      else:
        new_lines.append(line)

  text = '\n'.join(new_lines)
  return text


def format_markdown(markdown_text):
  # Function to ensure proper indentation and formatting within code blocks
  def format_code_block(code_block):
    formatted_code = '\n'.join('    ' + line
                               for line in code_block.strip().split('\n'))
    return f"```\n{formatted_code}\n```"

  # Regex pattern to find code blocks
  code_pattern = re.compile(r"```[a-z]*\n[\s\S]*?\n```")

  # List to hold formatted parts of the markdown
  formatted_parts = []

  # Start index for non-code text
  last_index = 0

  # Iterate over all matches of code blocks
  for match in code_pattern.finditer(markdown_text):
    # Get non-code text preceding the current code block
    non_code_text = markdown_text[last_index:match.start()].strip()
    if non_code_text:
      formatted_parts.append(non_code_text)

    # Get the code block, format it, and add to the list
    code_block = match.group()[3:-3]  # Remove the surrounding ```
    formatted_parts.append(format_code_block(code_block))

    # Update last index to the end of the current code block
    last_index = match.end()

  # Add any remaining non-code text after the last code block
  remaining_text = markdown_text[last_index:].strip()
  if remaining_text:
    formatted_parts.append(remaining_text)

  # Join all parts and return the formatted markdown
  return '\n\n'.join(formatted_parts)
