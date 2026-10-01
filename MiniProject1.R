#### PSYC 749 Mini-Project 1: Automated Item Generation ####
# Target Construct: Student Academic Achievement in PSYC 749 (Teacher Rating Scale)

# install.packages("ellmer")
library(ellmer)

Sys.setenv(
  MISTRAL_API_KEY = "My API key" # my API key
)

library(pdftools) 

# Syllabus File
syllabus_path <- "LLM_Syllabus_20260902.pdf" 

# combine text
syllabus_text <- paste(pdf_text(syllabus_path), collapse = "\n")

cat("Total characters:", nchar(syllabus_text), "\n") #23026 


#### 1. Common System Prompt (Instructor Persona) ####

model_name <- "ministral-8b-latest"

sys_prompt <- "You are a strict and pragmatic instructor for PSYC 749 
              (Quantitative & Individual Differences: LLMs in Psychometrics). 
              You evaluate students rigorously based on observable performance, 
              technical competency in R/Python APIs, and conceptual mastery, strictly 
              following syllabus criteria and assignment penalties."

Stem_Rule <- "
IMPORTANT OUTPUT RULES:
- Use the Item Stem VERBATIM for every item. Do not rewrite, paraphrase, or extend it.
- Only replace the bracketed placeholder [Incidental 1 : Topic] with the topic given in the Elements.
- Items must differ ONLY in their specific behavioral examples and level descriptors. Keep the stem, topic, and any specified Observable Variables unchanged.
"

#### 2. Experimental Conditions (User Prompts) ####

## [Condition 1: WEAK Theory Prompt]
Task1_Prompt_Weak_Instructions <- "
Based on the Item Stem, Elements, and Response Criteria, generate **exactly** 2 distinct parallel rating scale items for evaluating student performance.

1. Item Stem
\"The student is able to critique conceptual accuracy and logical coherence in a reaction paper on [Incidental 1 : Topic].\"

2. Elements :
[Incidental 1 (Paper Topic): Automated Item Generation (AIG)]

3. Response Criteria
Provide a 4-tier evaluation guide:
- Level 0 (None): No evidence of target skill execution.
- Level 1 (Limited): Incomplete or flawed execution.
- Level 2 (Moderate): Mostly correct execution with minor errors.
- Level 3 (Complete): Fully accurate and complete execution.
"

Task2_Prompt_Weak_Instructions <- "
Based on the Item Stem, Elements, and Response Criteria, generate **exactly** 3 distinct parallel rating scale items for evaluating student performance.

1. Item Stem
\"The student is able to apply R/Python code to execute LLM API calls and process computational outputs for [Incidental 1 : Topic].\"

2. Elements :
[Incidental 1 (Paper Topic): Automated Item Generation (AIG)]
[Incidental 2 : length of code and report]

3. Response Criteria
Provide a 4-tier evaluation guide:
- Level 0 (None): No evidence of target skill execution.
- Level 1 (Limited): Incomplete or flawed execution.
- Level 2 (Moderate): Mostly correct execution with minor errors.
- Level 3 (Complete): Fully accurate and complete execution.
"
Task3_Prompt_Weak_Instructions <- "
Based on the Item Stem, Elements, and Response Criteria, generate **exactly** 3 distinct parallel rating scale items for evaluating student performance.

1. Item Stem
\"The student is able to create a new measurement framework applying LLMs and psychometrics for [Incidental 1 : Topic].\"

2. Elements :

[Incidental 1 (Paper Topic): Applied LLMs in Psychometrics]
[Incidental 2 : length of code and report]

3. Response Criteria
Provide a 4-tier evaluation guide:
- Level 0 (None): No evidence of target skill execution.
- Level 1 (Limited): Incomplete or flawed execution.
- Level 2 (Moderate): Mostly correct execution with minor errors.
- Level 3 (Complete): Fully accurate and complete execution.
"

# Prompt + Syllabus
Prompt_Weak1 <- paste0("[Course Syllabus]\n", syllabus_text, "\n[End of Course Syllabus]\n\n", Task1_Prompt_Weak_Instructions, Stem_Rule)
Prompt_Weak2 <- paste0("[Course Syllabus]\n", syllabus_text, "\n[End of Course Syllabus]\n\n", Task2_Prompt_Weak_Instructions, Stem_Rule)
Prompt_Weak3 <- paste0("[Course Syllabus]\n", syllabus_text, "\n[End of Course Syllabus]\n\n", Task3_Prompt_Weak_Instructions, Stem_Rule)



## [Condition 2: STRONG Theory Prompt]
Task1_Prompt_Strong_Instructions <- "
Based on the Domain Specification, Cognitive Architecture, and Diagnostic Rubric Constraints provided below, generate **exactly** 2 distinct parallel rating scale items for evaluating student performance.

0. Item Stem
\"The student is able to critique conceptual accuracy and logical coherence in a reaction paper on [Incidental 1 : Topic].\"

1. COGNITIVE TAXONOMY MATRIX SPECIFICATION
Knowledge Dimension Category: Conceptual
Knowledge Subcategory: knowledge of principles and generalizations
Cognitive Process Category: Understand / Evaluate
Specific Cognitive Process Verb: comparing / critiquing
Target Taxonomy Cell: Cell B2 (Understand Conceptual Knowledge) / Cell B5 (Evaluate Conceptual Knowledge)

2. THREE-PANEL COGNITIVE ARCHITECTURE

TOP PANEL (Problem & Active Scenario)

primary domain : Automated Item Generation (AIG)
Active Scenario: Critique the student's use of exact concepts and the logical coherence of the reaction paper.
Task Goal : evaluate a student's conceptual knowledge and understanding

MIDDLE PANEL (Information Sources)

Primary Stimulus Sources:
[Source 1: Reaction papers]
[Source 2: discussion participation]
[Source 3: Considerations and late penalties in syllabus]

BOTTOM PANEL (Salient Features & Constraints)

Elements :
[Radical 1 : Implicit gap requiring reading between lines]
[Incidental 1 (Paper Topic): Automated Item Generation (AIG)]
[Note: Radicals are item-level features that determine the difficulty of the rating item itself; they are not flaws that the student's work must contain.]

Scenario Constraint :
[Constraint 1: The target Radical 1 MUST be set to 'Moderate' to ensure uniform item difficulty across all generated items.]

3. EVIDENCE MODEL EVALUATION RUBRIC (FOR CONSTRUCTED/OPEN-ENDED)
Extract the following Observable Variables: [Observable 1: Structural Integration], [Observable 2: Conceptual Accuracy].
Score using the 4-Tier Evidence Scale:
- Level 0 (None): No evidence of understanding or task execution.
- Level 1 (Limited): Incomplete relationships; major conceptual or structural flaws.
- Level 2 (Moderate): Clear execution with minor lapses or misunderstandings.
- Level 3 (Complete): Fully integrated, structurally sound, and accurate demonstration of target competency.

4. Diagnostic Rubric Tier Constraints
Level 0 (No Evidence): Demonstrates no understanding of paper's main objectives and concepts.
Level 1 (Diagnostic Misconception): Displays a specific conceptual error by confusing theory-based AIG structure.
Level 2 (Incomplete): Successfully defines primary concepts but presents incomplete synthesis or fails to logically connect theoretical principles.
Level 3 (Mastery): Fully satisfies all active scenario constraints and demonstrates complete, accurate execution without conceptual confusion about AIG.
"

Task2_Prompt_Strong_Instructions <- "
Based on the Domain Specification, Cognitive Architecture, and Diagnostic Rubric Constraints provided below, generate **exactly** 3 distinct parallel rating scale items for evaluating student performance.

0. Item Stem
\"The student is able to apply R/Python code to execute LLM API calls and process computational outputs for [Incidental 1 : Topic].\"


1. COGNITIVE TAXONOMY MATRIX SPECIFICATION
Knowledge Dimension Category: Procedural
Knowledge Subcategory: Knowledge of subject-specific techniques and methods
Cognitive Process Category: Apply
Specific Cognitive Process Verb: implementing
Target Taxonomy Cell: Cell C3 (Apply Procedural knowledge)

2. THREE-PANEL COGNITIVE ARCHITECTURE

TOP PANEL (Problem & Active Scenario)

primary domain : Automated Item Generation (AIG)
Active Scenario: Critique the completeness of the student's computational output and document.
Task Goal : evaluate whether a student applies procedural knowledge in practice.

MIDDLE PANEL (Information Sources)

Primary Stimulus Sources:
[Source 1: code]
[Source 2: output]
[Source 3: report document]
[Source 4: Considerations and late penalties in syllabus]

BOTTOM PANEL (Salient Features & Constraints)

Elements :
[Radical 1 : Moderate-level procedural bug in code execution]
[Incidental 1 (Project Topic): Automated Item Generation (AIG)]
[Incidental 2 : length of code and report]
[Note: Radicals are item-level features that determine the difficulty of the rating item itself; they are not flaws that the student's work must contain.]

Scenario Constraint :
[Constraint 1: The target Radical 1 MUST be set to 'Moderate' to ensure uniform item difficulty across all generated items.]

3. EVIDENCE MODEL EVALUATION RUBRIC (FOR CONSTRUCTED/OPEN-ENDED)
Extract the following Observable Variables: [Observable 1: Structural Integration], [Observable 2: Procedural Accuracy].
Score using the 4-Tier Evidence Scale:
- Level 0 (None): No evidence of understanding or task execution.
- Level 1 (Limited): Incomplete relationships; major procedural or structural flaws.
- Level 2 (Moderate): Clear execution with minor lapses or misunderstandings.
- Level 3 (Complete): Fully integrated, structurally sound, and accurate demonstration of target competency.

4. Diagnostic Rubric Tier Constraints
Level 0 (No Evidence): Demonstrates no understanding of script elements or procedural steps.
Level 1 (Diagnostic Misconception): Displays a specific procedural error by misunderstanding API control parameters or computational output structures.
Level 2 (Incomplete): Successfully configures basic API calls but presents incomplete execution in output handling or parameter binding (e.g., seed/temperature).
Level 3 (Mastery): Fully satisfies all active scenario constraints and demonstrates complete, accurate execution of R/Python API scripts for AIG without procedural errors.
"

Task3_Prompt_Strong_Instructions <- "
Based on the Domain Specification, Cognitive Architecture, and Diagnostic Rubric Constraints provided below, generate **exactly** 3 distinct parallel rating scale items for evaluating student performance.

0. Item Stem
\"The student is able to create a new measurement framework applying LLMs and psychometrics for [Incidental 1 : Topic].\"

1. COGNITIVE TAXONOMY MATRIX SPECIFICATION
Knowledge Dimension Category: Conceptual Knowledge / Procedural Knowledge
Knowledge Subcategory: Knowledge of principles and generalizations / knowledge of criteria for determining when to use appropriate procedures
Cognitive Process Category: Analyze / Create
Specific Cognitive Process Verb: Organizing / Producing
Target Taxonomy Cell: Cell B4 (Analyze Conceptual Knowledge) / Cell B6 (Create Conceptual Knowledge) / Cell C6 (Create Procedural Knowledge)

2. THREE-PANEL COGNITIVE ARCHITECTURE

TOP PANEL (Problem & Active Scenario)

primary domain : Applied LLMs in Psychometrics
Active Scenario: Critique the completeness of the student's final project and construction of presentation.
Task Goal : evaluate the originality of the student's work and the student's ability to apply knowledge

MIDDLE PANEL (Information Sources)

Primary Stimulus Sources:
[Source 1: code]
[Source 2: output]
[Source 3: report document]
[Source 4: presentation]
[Source 5: Considerations and late penalties in syllabus]

BOTTOM PANEL (Salient Features & Constraints)

Elements :
[Radical 1 : methodological complexity]
[Incidental 1 (Project Topic): Applied LLMs in Psychometrics]
[Incidental 2 : length of code and report]
[Note: Radicals are item-level features that determine the difficulty of the rating item itself; they are not flaws that the student's work must contain.]

Scenario Constraint :
[Constraint 1: The target Radical 1 MUST be set to 'Moderate' to ensure uniform item difficulty across all generated items.]

3. EVIDENCE MODEL EVALUATION RUBRIC (FOR CONSTRUCTED/OPEN-ENDED)
Extract the following Observable Variables: [Observable 1: Structural Integration], [Observable 2: Conceptual Accuracy].
Score using the 4-Tier Evidence Scale:
- Level 0 (None): No evidence of understanding or task execution.
- Level 1 (Limited): Incomplete relationships; major conceptual or structural flaws.
- Level 2 (Moderate): Clear execution with minor lapses or misunderstandings.
- Level 3 (Complete): Fully integrated, structurally sound, and accurate demonstration of target competency.

4. Diagnostic Rubric Tier Constraints
Level 0 (No Evidence): Demonstrates no understanding of psychometric framework design, LLM integration, or project execution.
Level 1 (Diagnostic Misconception): Displays a specific structural/conceptual error by producing output without applying core psychometric evaluation standards to the proposed LLM workflow (e.g., consistency, validity).
Level 2 (Incomplete): Successfully applies LLMs to a psychometric problem, but presents incomplete methodological uniqueness or weak synthesis in the final project.
Level 3 (Mastery): Fully satisfies all active scenario constraints and demonstrates complete, creative output of LLM frameworks within psychometrics with flawless methodology and presentation structure.
"

# Prompt + Syllabus
Prompt_Strong1 <- paste0("[Course Syllabus]\n", syllabus_text, "\n[End of Course Syllabus]\n\n", Task1_Prompt_Strong_Instructions, Stem_Rule)
Prompt_Strong2 <- paste0("[Course Syllabus]\n", syllabus_text, "\n[End of Course Syllabus]\n\n", Task2_Prompt_Strong_Instructions, Stem_Rule)
Prompt_Strong3 <- paste0("[Course Syllabus]\n", syllabus_text, "\n[End of Course Syllabus]\n\n", Task3_Prompt_Strong_Instructions, Stem_Rule)

#### 3. Item Generation (API Calls) ####

## Condition 1 (Weak Theory)
start_time <- Sys.time()

# Generate items and save result
resp_weak1 <- chat_mistral(system_prompt = sys_prompt, model = model_name,
                           params = params(temperature = 0.0, seed = 929))$chat(Prompt_Weak1, echo = FALSE)
resp_weak2 <- chat_mistral(system_prompt = sys_prompt, model = model_name,
                           params = params(temperature = 0.0, seed = 929))$chat(Prompt_Weak2, echo = FALSE)
resp_weak3 <- chat_mistral(system_prompt = sys_prompt, model = model_name,
                           params = params(temperature = 0.0, seed = 929))$chat(Prompt_Weak3, echo = FALSE)

end_time <- Sys.time()
time_taken <- end_time - start_time
cat("\n[Time taken for 8 items]:", round(time_taken, 2), attr(time_taken, "units"), "\n") # around 22.73 secs 

cat(resp_weak1, resp_weak2, resp_weak3)


## Condition 2 (Strong Theory)
start_time <- Sys.time()

# Generate items and save result
resp_strong1 <- chat_mistral(system_prompt = sys_prompt, model = model_name,
                             params = params(temperature = 0.0, seed = 929))$chat(Prompt_Strong1, echo = FALSE)
resp_strong2 <- chat_mistral(system_prompt = sys_prompt, model = model_name,
                             params = params(temperature = 0.0, seed = 929))$chat(Prompt_Strong2, echo = FALSE)
resp_strong3 <- chat_mistral(system_prompt = sys_prompt, model = model_name,
                             params = params(temperature = 0.0, seed = 929))$chat(Prompt_Strong3, echo = FALSE)

end_time <- Sys.time()
time_taken <- end_time - start_time

cat("\n[Time taken for 8 items]:", round(time_taken, 2), attr(time_taken, "units"), "\n") #around 30.79 secs

cat(resp_strong1, resp_strong2, resp_strong3)


#### 4. Save Results for Report (Optional) ####
# Save as a file. Go to Step 6 & 7
writeLines(
  c("=== Condition 1: Weak Theory Items ===",
    "--- Task 1 ---", resp_weak1,
    "--- Task 2 ---", resp_weak2,
    "--- Task 3 ---", resp_weak3,
    "\n\n==========================================\n\n",
    "=== Condition 2: Strong Theory Items ===",
    "--- Task 1 ---", resp_strong1,
    "--- Task 2 ---", resp_strong2,
    "--- Task 3 ---", resp_strong3),
  con = "generated_items_output2.txt"
)
cat("\nMission Complete! 'generated_items_output.txt' was Saved \n")
