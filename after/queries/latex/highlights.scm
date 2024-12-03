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
