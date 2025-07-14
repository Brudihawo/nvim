; extends

; Turn off spelling in itemize config
(generic_command
  (command_name) @name
  (#any-of? @name 
   "\\setlist"
   "\\setitemize"
   "\\ce"
   )) @nospell

(label_definition
  (curly_group_text) @name) @nospell

(begin
  command: _ @env_cmd)

(end
  command: _ @env_cmd)

(section
  command: _ @section)
(subsection
  command: _ @section)
(subsubsection
  command: _ @section)
(paragraph
  command: _ @section)

(label_definition
  (curly_group_text
    (text) @label_name))

(label_reference
  (curly_group_text_list
    (text) @ref))

(citation
  keys: (curly_group_text_list
          (text) @citekeys))

(brack_group_key_value
  (key_value_pair
    key: (text) @keylabel
    value: (value)))

(generic_environment
  (begin
    (curly_group_text
      (text) @name
      (#not-eq? @name "document"))
    (brack_group) @env_opts @nospell)
  )

(generic_command
  (command_name) @cmd_name
  (#eq? @cmd_name "\\todo")
  (curly_group
    (text) @todo_text)) @todo_cmd

(generic_environment
  (begin
    (curly_group_text
      (text) @env_name
      (#any-of? @env_name
         "tabular"
         "tabularx"
         "tabulary")))
  (curly_group (text) @nospell))

(author_declaration
  _ @author_cmd
  (curly_group_author_list
    (author)) @authors)

(title_declaration
  _ @title_cmd
  (curly_group
    (text)) @title)

(generic_command
  (command_name) @date_cmd
  (#eq? @date_cmd "\\date")) 

(text_mode
  (curly_group
    (text) @math_text))

(generic_command
  (command_name) @cmd_name
  (#eq? @cmd_name "\\mathrm")
  (curly_group
    (text) @math_text))

(generic_command
  (command_name) @cmd_name
  (#eq? @cmd_name "\\vec")
  (curly_group
    (text) @vec)
  )
