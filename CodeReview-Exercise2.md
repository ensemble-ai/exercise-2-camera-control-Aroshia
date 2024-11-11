# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Andrew Lov 
* *email:* aklov@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation of position lock works exactly as intended, where the code is concise and intuitive as to what it does. The camera and player are always at the same position.
___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The box is drawn correctly, and the auto scroll works as intended, moving to the right. However, the push box functionality doesn't work, where the player is just trapped inside of the box and cannot manipulate the direction of the camera.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for the lerp with position lock works as intended, where the camera follows the player at a slower speed and the target is unable to break the leash. The player is always within the max distance of the camera. There are a few visual issues with how the target jumps around when going at hyper speed, however.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
When switching cameras to the lerp with smoothing, where the camera leads the player, the camera must move to the target's location again without the location being immediately set when switching to the camera. When moving normally, the camera leads the player as intended, where the player hits the max distance if the camera moves too far away. However, when entering hyper speed, the camera does not follow the player as intended, and the camera starts teleporting to various locations rather than smoothly leading the target. Additionally, the catchup_delay_duration isn't implemented correctly, as the camera immediately moves back to the position of the target after the release of input.

___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Most of the 4 way push zone functionality is correct, where the player is unable to move inside the innermost square of the push zone. However, within the speed-up zone, on the left and right outside the smaller box, going up and down does not result in any movement. The code also seems to correctly account for the overlap when in the push zone and the speed up zone.
___
# Code Style #


#### Style Guide Infractions ####

There are some instances where the style guide regarding logical operators are infringed upon, such as in the line https://github.com/ensemble-ai/exercise-2-camera-control-Aroshia/blob/cb3010d790b712f12b2c8362de5becbfd3aea9ee/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L62
This shows the use of the "!" operator rather than the use of the word 'not' suggested by the Godot Script Style guide

The order of variable declarations are not completely perfect, as there are some variable declarations that should appear after the @export variables instead of before it https://github.com/ensemble-ai/exercise-2-camera-control-Aroshia/blob/cb3010d790b712f12b2c8362de5becbfd3aea9ee/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L5

Some portions of the code show spacing of less than two lines between each function, which do not follow the style guide for Godot. https://github.com/ensemble-ai/exercise-2-camera-control-Aroshia/blob/cb3010d790b712f12b2c8362de5becbfd3aea9ee/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L17-L19

#### Style Guide Exemplars ####

The use of snake_case for variables and functions and camelCase for class names is closely adhered to, making the names easily understandable and standardized.

Most of the exported variables are specified with a return type, reducing the chances of errors regarding the variable and is good practice. https://github.com/ensemble-ai/exercise-2-camera-control-Aroshia/blob/cb3010d790b712f12b2c8362de5becbfd3aea9ee/Obscura/scripts/camera_controllers/four_way_speed_push.gd#L13

# Best Practices #

#### Best Practices Infractions ####

There are some portions of code that infringe on readability practices, such as the lack of spacing in some assignments that use multiple variables. https://github.com/ensemble-ai/exercise-2-camera-control-Aroshia/blob/cb3010d790b712f12b2c8362de5becbfd3aea9ee/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L64

#### Best Practices Exemplars ####

All export variables that were required in each stage were declared, following guidelines. 

One practice that seemed quite helpful was the inclusion of various forms of debugging and checking the code. When playing the game, there is an overlay that displays certain information about the target such as its velocity and position. These components can be helpful in trying to understand what might be causing problems for certain implementation, and generally seems beneficial in debugging any issues.

Comments are used to summarize statements that might seem hard to follow, streamlining the readability of the code. https://github.com/ensemble-ai/exercise-2-camera-control-Aroshia/blob/cb3010d790b712f12b2c8362de5becbfd3aea9ee/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L62


