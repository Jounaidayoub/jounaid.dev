---
title: "Deconstructing Coding Agents: A Developer's Mental Model (Part 1)"
pubDate: '2026-05-18'
---

if you aer a softwae developer . the last year was probaly a huge shift in termsk of the inudsot and what are we supposed to do , these clankers are not just a trend anymore ,there are here to stay , these things -- LLMs are really intersing for me , they make these tools called agetns , which are even more powserfull ,everyone one work with them nowday, what ever are u using Claude Code , OpenCode , Cursor , copolot what ever , a coding agent now is like an ide for tradional devolperr , its really hard to work with ai atm but hte problem is do u really understand how it works , what happens when type a prompt and hit enter , how does it do things , they say llm are just next token predictors , but these claude can make wonders adn run an do actiosn , hows that connect , so i decied to make this arctial to share what i see is very important , the mental model , the intituin u need to build for these things as devopper ,cuz once u have that u will start to see their limits , what they can do or not -techinacly- , the usecases , here am talking about agents in genral not just in code , they will start to be potential candidates for problems that u will encounter , cuz u understand the whole picture and what is about ,and trust me is really simple than it seems ,

---

# The core : LLMs

before we starting taking abotu allms , i want to make clear that is will not cover the theary and how does an llm work inernaly thats an implemtiontaion detail that is not very impiratant to u as software guy , it is helpfull yes but there more imporatn siff , it not there whenr u would ge thet most value to work with them

i want u to think about llms as black box , very big thing powerfull thing , a fuction that takse string of text (just text for now ) and it produces some text back , so thing of as this

```typescript
function LLM(input: string): string {
  // does a lot of math and stuff , what we dont care about (for now , its fun though)
  return predictedText
}
```

that liitery what u need for now , text in , text out , some special stuff about htis function

- this function is statless , it does not rember anything about us ,and does nto has anything from the previews call ,it start fresh on each
  call
- this function is not determicn , what does mean ? it means that i can call it `LLM("hello , how are u doing ")` two diffrently times and thre not garrenties that i will get the same outfou l so same input , diffrent output on each , call , cuz as we said its just probalisc mahicne u give it some text in give some text back ,

ok so good so far , i habe function i can call it withsome text and it will predicet what would that ntext com righ t, yes

for example i can say `llm('hello , who are you')` and the output with be mayb something liek `?` , or another quesion , thay littey the most likely thing
for my stateme the qesiotna makr , or soome other quesiton or i can say `llm('what worst language in the world')` and it maybe genrate with another quesiotn as noutput , so the ones who made this function tune it in away that it not only generat ehte most likey word/text , it would gernate a helpfupp response , it sitll the same conetp conet fo most likey , it just gave it perosnaly and say what would helpfull assitatn would say give this picen of text , which is an helpful asnwser , so now instead of it just geenralcy give us the most likery text it would genrat hte lost likey helpfull repsonse an assitant would gave so `llm('hello , who are u ')` would result in myabe something `i am helpfull assitant ` , and `llm('what the workst languate int he word')` woudl result in somtehing lilke `javascript`
also sotmehng i didnt menton that this function os very powserufll it saw huge amoutn of knowlegt and being traned on vast resoucres acrorss the internt , so we can ask it like `llm('explain how python corotines work')` and i would genrate a good looking explanation abou this subgne , u can pass this functon picre of code nad tell to explain it for u , this great so far , what great super function
but we begin to see problem it doesn actyl rember anything , if iwantt= followe up i cant , i have to make new call from scratch wiht nothing saved from the previews questios ,
let thing of a solution , let just savet those messages somee

---

# Phase 1: The Foundation (LLMs are just Text Predictors)

If you want to understand agents, you have to start by completely demystifying the LLM (Large Language Model) itself.

Forget the idea of an "AI brain." Think of an LLM as a pure, stateless mathematical function. You give it a string of text (tokens), and it returns the statistically most likely _next_ string of text. That's it. Text in, text out.

```javascript
// The mental model of a raw LLM
function rawLLM(inputString) {
  // ... massive matrix multiplications happen here ...
  return predictedNextString
}

rawLLM('The sky is ') // returns "blue."
```

During its pre-training, the model read the whole internet, so it knows a lot of facts. During its "post-training," it was tuned to be helpful. So if you give it a question, the statistically most likely next text it should generate is the answer.

But there is a massive catch, and you need to keep this in your head for the rest of this post: **An LLM is completely stateless.**

It does not remember you. It does not remember the question you asked 5 minutes ago. It is a black box that wakes up, looks at the text you _just handed it_, predicts the next few words, and goes back to sleep.

# Phase 2: The Chatbot Illusion (Context & Memory)

So, if an LLM is completely stateless, how does ChatGPT remember your name? How does it hold a fluid conversation?

Well, it doesn't. _You_ do. Or rather, the application wrapper around the LLM does.

To make an LLM act like a conversational assistant, developers use a clever trick: they keep a running transcript of the entire conversation and send the _whole thing_ back to the LLM every single time.

Imagine we are talking.

1. **User:** "Hi, my name is Ayoub."
2. **LLM:** "Nice to meet you, Ayoub!"

When I ask my next question, the application doesn't just send my new question. It sends the entire history.

```json
// What our code actually sends to the API
[
  { "role": "user", "content": "Hi, my name is Ayoub." },
  { "role": "assistant", "content": "Nice to meet you, Ayoub!" },
  { "role": "user", "content": "What is my name?" }
]
```

The LLM wakes up, reads the entire transcript from the top, sees that the last user said "What is my name?", looks up slightly to see "my name is Ayoub", and generates: "Your name is Ayoub."

This is what we mean when we talk about **Context**.

The "Context Window" is simply the maximum amount of text you can shove into this array before the model runs out of memory and crashes. Every time you chat, the context grows incrementally larger.

### Steering the Ship: The System Prompt

Once you realize that the LLM is just reading a transcript and playing a character, you can inject hidden instructions at the very top of the transcript to control how it behaves. This is called a **System Prompt**.

```json
[
  { "role": "system", "content": "You are a grumpy pirate. Only speak in pirate slang." },
  { "role": "user", "content": "Hello!" }
]
```

Because the LLM reads top-to-bottom, the system prompt sets the rules for the rest of the generation.

At this point, we've built a chatbot. It can answer questions, remember the conversation history (because we keep feeding it back to it), and play a character.

But let's be honest... it's still stuck inside a text box. It can't _do_ anything. It can't read your local files, it can't check the weather, and it definitely can't run code.

To make it do those things, we need to cross the bridge from "Chatbot" to "Agent."

---

# Phase 3: From Chatbot to Agent (Tool Calling)

So we have a chatbot that remembers things. But how do we get a text-prediction engine to actually act in the real world?

The answer is surprisingly low-tech: **String matching and a protocol.**

Let's build the intuition first before looking at production code. Imagine you write a system prompt that says:

> _"If the user asks for the weather, do not try to answer natively. Instead, output the exact string: `[GET_WEATHER: <city>]` and stop talking."_

If the user says "What's the weather in Tokyo?", the LLM will predict that the best response is `[GET_WEATHER: Tokyo]`.

Now, back in the code that we write around the LLM, we aren't just blindly printing the output to the screen anymore. We are inspecting it.

```javascript
// Our application code (The wrapper around the LLM)
let llmResponse = callLLM(context)

if (llmResponse.includes('[GET_WEATHER:')) {
  // 1. We extract the city using a simple regex
  let city = extractCity(llmResponse)

  // 2. WE (our code) make the actual API call
  let weatherData = fetchRealWeatherAPI(city)

  // 3. We append the result to the context and call the LLM again!
  context.push({
    role: 'system',
    content: `Tool Result: The weather in ${city} is ${weatherData}`
  })

  let finalResponse = callLLM(context)
  print(finalResponse)
}
```

**This is the biggest "aha" moment in understanding agents.**

The LLM didn't call the weather API. The LLM has no internet connection. The LLM just generated a specific string of text. _Our code_ intercepted that text, did the actual work, and then whispered the answer back into the LLM's context window.

> 💡 **Side Note: What is a "Harness"?**  
> If English isn't your first language, think of a harness like the straps you put on a horse to attach it to a carriage, or a safety harness you wear while climbing. It is the structural framework that directs raw power.
>
> In AI, the LLM is the raw engine, and the code we write around it (the loops, the `if` statements, the API calls) is the **Harness**. From here on out, we're going to use the term "Harness" to describe our code!

### Tool Calling in Production

Today, you don't have to write messy regular expressions to do this. AI providers like OpenAI and Anthropic formalized this into a feature called **Tool Calling**.

Under the hood, modern models don't just output normal text for tools; they use special, hidden "control tokens" (like `<|tool_call|>`) that tell the API, "Hey, I'm trying to use a tool." The provider's API catches these special tokens and formats them nicely for us.

Here is what a real OpenAI-compatible API call looks like. Instead of just sending messages, we also send a JSON description of our tools:

```json
// What the Harness sends to the LLM
{
  "messages": [{ "role": "user", "content": "What's the weather in Tokyo?" }],
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "get_weather",
        "description": "Get current temperature for a city",
        "parameters": {
          "type": "object",
          "properties": {
            "location": { "type": "string" }
          }
        }
      }
    }
  ]
}
```

The LLM sees this menu of tools, realizes it needs one, and instead of generating a normal text response, the API returns this exact JSON payload back to our Harness:

```json
// The response the LLM gives to our Harness
{
  "role": "assistant",
  "content": null,
  "tool_calls": [
    {
      "id": "call_9876",
      "type": "function",
      "function": {
        "name": "get_weather",
        "arguments": "{\"location\": \"Tokyo\"}"
      }
    }
  ]
}
```

Look closely at that response. The `content` is null! The LLM didn't say anything to the user. It just filled out the JSON form we asked it to.

Our Harness sees this `tool_calls` array, pauses the LLM, executes our local `get_weather` function with the argument `"Tokyo"`, and sends the result back. The underlying mechanics are exactly the same as our string-matching intuition: The LLM asks, the Harness executes, the Harness feeds the result back.

---

## Phase 4: Giving the Agent Hands (The Bash Loop)

Once you understand Tool Calling, the leap to a "Coding Agent" is actually quite small.

If we can give the LLM a tool to check the weather, we can give it a tool to run terminal commands. Let's give it a tool called `execute_bash`.

Here is exactly what happens when you ask an agent like Cline or Devin: _"How much disk space do I have left?"_

1. **The System Prompt:** We tell the LLM, _"You are a coding assistant. You have access to an `execute_bash` tool. Use it to explore the user's system."_
2. **The LLM Thinks:** It sees the user's question. It realizes it doesn't know the answer, but it knows the `df -h` command will find out.
3. **The Tool Call:** The LLM outputs a JSON request to use `execute_bash` with the argument `df -h`.
4. **The Execution:** Our Harness pauses the LLM, takes the `df -h` command, runs it safely in a real terminal, captures the text output, and appends it to the conversation history.
5. **The Final Answer:** The LLM reads the new context containing the terminal output, and generates: _"You have 45GB of free space on your root drive."_

This is the **Agentic Loop**: _Observe, Think, Act, Verify._

The LLM isn't just answering once. It is caught in a `while` loop inside our Harness.

- It looks at the context.
- It decides to call a tool.
- We run the tool and append the result.
- It looks at the context again.
- If it needs more info, it calls another tool. If it has the answer, it responds to the user and breaks the loop.

This is how an agent can debug a massive codebase. It calls a `read_file` tool, looks at the code, calls a `grep` tool to find where a variable is used, looks at those results, and then calls an `edit_file` tool to fix the bug.

It is just a text predictor inside a loop, reading an ever-growing transcript of its own actions, until the task is done.

---

# Phase 5: Agent Skills and Context Management

As you build agents, you'll quickly run into a major problem: **Context Bloat**.

Let's say you want your coding agent to know how to write a perfect git commit message, how to format your company's release notes, and how to query your Jira board. The naive approach is to dump all those detailed instructions into the System Prompt.

But remember Phase 2? The Context Window is finite. If you stuff 10,000 words of custom instructions into every single conversation, three bad things happen:

1. You run out of memory for actual code.
2. The API calls become incredibly expensive (you pay per token).
3. The LLM suffers from "Lost in the Middle" syndrome, where it literally forgets instructions buried in the middle of a massive prompt.

To solve this, developers introduced **Skills**.

A "Skill" is just a fancy word for a chunk of reusable prompt instructions. But instead of loading them all upfront, we use **Progressive Disclosure**.

We give the LLM a new tool called `use_skill(skill_name)`. In the System Prompt, we only give the LLM the _names_ and a brief one-line description of available skills.

```text
// Inside the System Prompt
Available Skills:
- vacation_planner: Use when asked to plan a trip.
- release_notes: Use when asked to draft GitHub releases.

If you need these instructions, call the `use_skill` tool.
```

If you ask the agent, "Draft a release note", it uses the tool: `use_skill("release_notes")`. Our Harness intercepts this, reads the heavy Markdown file containing the actual release note instructions from your hard drive, and injects _only that content_ into the context window.

By dynamically loading prompts only when they are needed, we keep the context window small, fast, and highly focused.

---

# Phase 6: Scaling Tools with MCP (Model Context Protocol)

We now have an agent that can run tools and dynamically load skills. But there is one final bottleneck: where do the tools actually live?

Until recently, if you wanted your agent to be able to search GitHub or query a PostgreSQL database, you had to write the Javascript or Python code for that tool directly into your Agent Harness.

This doesn't scale. If I write a great tool for querying Jira, you can't easily use it in your agent without copy-pasting my code. Worse, enterprise companies don't want to give a random open-source agent direct source-code access to their private databases.

Enter **MCP (Model Context Protocol)**.

MCP decouples the _description_ of a tool from the _execution_ of the tool.

Instead of writing tools into the agent, you run an independent **MCP Server**. This server exposes tools over a standardized JSON-RPC connection.

Here is how the flow works now:

1. **Discovery:** Your Agent (the Client) pings the MCP Server: "What tools do you have?"
2. **Context Loading:** The Server replies: "I have a `query_jira` tool." The Agent adds this JSON description to the LLM's context window.
3. **The Call:** The LLM decides to use `query_jira`.
4. **Remote Execution:** Instead of executing the code locally, your Harness sends the tool call request _over the network_ (via JSON-RPC) to the MCP Server.
5. **The Result:** The MCP server executes the secure code on its end, fetches the Jira ticket, and sends the text back to the Agent.

This is revolutionary. You can now build plug-and-play tools. You can point Claude Desktop to your company's internal MCP server, and suddenly Claude knows how to query your private user database—without OpenAI or Anthropic ever seeing your backend code, and without you having to write a custom agent harness.

---

# The Big Picture

When you step back, the illusion of the "AI Brain" disappears.

What you actually have is a stateless text predictor, trapped in a while loop, reading a transcript of its own actions, dynamically loading instructions (Skills) when it gets stuck, and sending JSON strings to remote servers (MCP) to interact with the world.

It is just code, strings, and loops. But when you put them all together, it feels like magic.
