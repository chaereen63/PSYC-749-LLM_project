#----- PSYC 749 Mini-Project 2: Automated Item Generation ----#
library(tidyverse)

#### 1. Choose data ####
essay <- read_csv("essays.csv")

(data <- essay[1:10,])

nrow(data)

onlyEssay <- data %>% select("AUTHID", "TEXT")

#### 3. Score by yourself ####
extra1 <- c(1,2,3,4,5,1,2,3,4,5) # EJ
(Human1 <- data.frame(data[,1, drop = F], human1 = extra1))

extra2 <- c(4,4,4,4,5,5,4,3,2,1) # CK
(Human2 <- data.frame(data[,1, drop = F], human2 = extra2))

Humans <- merge(Human1, Human2, by = "AUTHID")
  
#### 4. Prompt ####
model_name <- "ministral-8b-latest"

sys_prompt1 <- "you are psychologist"
sys_prompt2 <- "you are closed friend with AUTHIDs" #expert or not?

Rubric_Prompt <- "
Score extraversion using the 5 Evidence Scale

- 1 : Deeply inward and highly reflective. Focuses almost entirely on abstract concepts,self-analysis, or internal monologue. Expresses feeling drained by social interaction or a strong desire for solitude. Low-energy, passive, or observant tone.
- 2 : Quiet, reserved, and reflective. Mentions solitary hobbies, low-key activities, or intimate settings. Mentions people occasionally, but views social interactions as secondary to internal thought. Deliberate, cautious thought flow.
- 3 : Balanced ambivert. Shifts naturally between internal reflections and external activities/social interactions. Mentions time with others and solitary time with equal frequency and neutral-to-positive tone. Steady, moderate pace.
- 4 : Outwardly focused, social, and action-oriented. Frequently references friends, gatherings, events, and future plans. Upbeat, expressive tone with active verbs. Seeks out activity or social connection to avoid boredom.
- 5 : Hyper-focused on the external world, people, and high stimulation. Continuous references to crowds, social plans, and dynamic settings. Rapid, highly enthusiastic, and impulsive thought flow. Strongly energized by others; deep aversion to solitude or inactivity

Data to score:
%s

Return **only** a **csv** format with header 'AUTHID, extra'.
Example format:
AUTHID, extra
1997_504851.txt,1
1997_605191.txt,2

- only give extraversion score per essay
- no other explaination or markdown code block
"
Prompt1 <- paste0("[Essay List]\n", onlyEssay, "\n[End of Essay List]\n\n", Rubric_Prompt)


#### 5. Obtain LLM scores ####
library(ellmer)

Sys.setenv(
  MISTRAL_API_KEY = "mstrl_XELnUCrALVlbBpFKy6RcuDLq56HBq1xN_0qS3I6" # my API key
)

con1 <- chat_mistral(system_prompt = sys_prompt1, model = model_name,
                     params = params(temperature = 0.0, seed = 1015))$chat(Prompt1, echo = FALSE)
con2 <- chat_mistral(system_prompt = sys_prompt2, model = model_name,
                     params = params(temperature = 0.0, seed = 1015))$chat(Prompt1, echo = FALSE)

con1Score <- read.csv(text = con1, stringsAsFactors = F)
con2Score <- read.csv(text = con2, stringsAsFactors = F)
AIs <- merge(con1Score,con2Score, by = "AUTHID", suffixes = c("_AI1", "_AI2"))

#### 6. Inter-rater reliability coefficient ####
## marge data
(Final <- merge(Humans, AIs, by = "AUTHID"))
  # human; ai
  humans <- Final %>% select("human1","human2"); ais <- Final %>% select("extra_AI1", "extra_AI2")
  # total
  rank <- Final %>% select("human1","human2", "extra_AI1", "extra_AI2")

## Analysis
# install.packages("irr")
library(irr)
# correlation
corHU <- cor.test(Final$human1, Final$human2)
corAI <- cor.test(Final$extra_AI1, Final$extra_AI2)

{cat("[Correlation between humans or between AIs]\n")
corHU; corAI}

# Kendall's W
#WWW
kendall(humans);kendall(ais) ;kendall(rank)

## Plot
library(ggplot2)

ggplot(Humans, aes(x = AUTHID)) +
  geom_jitter(aes(y = human1, color = "Human1"), width = 0.1, height = 0.02) +
  geom_jitter(aes(y = human2, color = "Human2"), width = 0.1, height = 0.02) +
  scale_color_manual(values = c(Human1 = "blue", Human2 = "tomato"))

ggplot(AIs, aes(x = AUTHID)) +
  geom_jitter(aes(y = extra_AI1, color = "AI1"), width = 0.1, height = 0.02) +
  geom_jitter(aes(y = extra_AI2, color = "AI2"), width = 0.1, height = 0.02) +
  scale_color_manual(values = c(AI1 = "blue", AI2 = "tomato"))

#### Finish!!!