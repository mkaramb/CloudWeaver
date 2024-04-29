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
