---
name: JOJO_style_postcard
description: Draw a 1080x1920 px postcard using nano banana's latest model in Japanese manga JOJO style based on a user-provided theme. Saves the output as a JPG in the "postcard" folder with the current timestamp.
---

# JOJO Style Postcard

This skill guides the agent to generate a postcard image in the iconic Japanese manga style of JOJO's Bizarre Adventure. 

## Workflow Instructions

When the user provides a theme to draw, follow these exact instructions:

1. **Understand the Request**: 
   The user will provide a theme. Your task is to generate an image based on that theme.

2. **Reference Images**:
   - Check the `references/` directory within this skill's folder (`/Users/huang/Documents/07_vibeCoding/yipinSills_demo/JOJO_style_postcard/references/`).
   - If there are images, pass their absolute paths (up to 3) into the `ImagePaths` argument of the `generate_image` tool to study and learn the authentic JOJO style from them.

3. **Image Generation**:
   - **Model**: Instruct the image generation tool to use "nano banana's latest model" (or add "nano banana latest model" to the prompt to simulate this requirement if using standard tools).
    - **Style**: Japanese Manga, Hirohiko Araki style (JOJO's Bizarre Adventure). Emphasize: **bold ink lines**, **"JOJO Poses"** (dramatic, fashionable), **heavy crosshatching**, **unconventional color palettes**, and **distinctive facial shading**.
   - **Dimensions**: The postcard MUST be exactly 1080x1920 px (portrait orientation). Verify this in the generation tool parameters.
   - **Content**: Incorporate the user's provided theme into the JOJO style.

## JOJO Style Profile

When generating images, the following core features must be emphasized:

### 🎨 Visual & Composition
1. **The Poses (JOJO 立)**: Characters should strike highly dynamic, often anatomically impossible, high-fashion-inspired poses.
2. **Bold Inking**: Use very thick, strong black outlines.
3. **Crosshatching (荒木線)**: Dense parallel and intersecting lines for shading on muscles, under eyes, and in clothing folds.
4. **Onomatopoeia (擬聲詞)**: Stylized Japanese katakana like "ゴゴゴ" (GOGOGO) or "ドドド" (DODODO) can be part of the background composition.

### ✨ Shading & Colors
1. **Dramatic Shadows**: Deep, high-contrast shadows especially on the face (nose wings, eye sockets).
2. **Vibrant lips**: Characters often have full, well-defined, and sometimes brightly colored lips.
3. **Surreal Colors**: Don't shy away from non-literal colors (e.g., purple skies, neon skin highlights) to evoke emotion.

3. **Save the Result**:
   - **Directory**: Ensure a folder named `postcard` exists in the current working directory.
   - **Filename**: Determine the current time and format it as `YYYY_MM_DD_HH_MM_SS.jpg`.
   - **Format**: JPG.
   - **Action**: Use the `generate_image` tool, capture the artifact path, and run a bash command to move it to `./postcard/<YYYY_MM_DD_HH_MM_SS>.jpg`.

### Example Agent Execution Pattern:
1. User: "Use JOJO_style_postcard skill. Theme: a cat drinking coffee."
2. Agent: Calls `list_dir` on `references/` to find reference images or analysis.
3. Agent: Calls `generate_image` with prompt: "A 1080x1920 portrait postcard of a cat drinking coffee in JOJO style. Features: dramatic pose, bold black inking, heavy crosshatching on muscles/face, vibrant pouted lips, and GOGOGO background sfx. High-fashion aesthetics, nano banana latest model quality. Colors: surreal high-contrast."
4. Agent: Moves the result to `./postcard/`.
