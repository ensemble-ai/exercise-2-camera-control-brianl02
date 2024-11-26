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

* *name:* [Ruben Leon Jarquin] 
* *email:* [rjleon@ucdavis.edu]

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

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Met the objectives and changed camera global position to target global position in _process. 

___
### Stage 2 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Met the objectives of having a constant moving camera that pushes the player when the player lags behind the border.

___
### Stage 3 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
In terms of meeting the objectives, the students accomplished all of them. There is only one slight flaw with the student's implementation. When the user is at hyperspeed, the range of motion is limited to the following degrees of motion: 0, 45, 90, 135, 180, 225, 270, 315, and 360. I presume the issue with the way you set your direction at the following [line](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/lerp_smoothing_pl.gd#L53).  

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [X] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The student accomplished all the objectives, but that larger motion needs to fix a significant flaw. Specifically, whenever the player executes a specific motion and then executes a different one, the camera teleports to the opposite side of the player's direction. The teleporting motion applies when the player is both at regular speed and when the player is outside of the leash distance. These sudden changes in position are a noticeable flaw that compromises the smooth interpolative aspect of the camera. If the student fixed the interpolative, then the score would be perfect.

I'm not entirely sure about this, but  I believe the issue is how the [direction](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/target_focus.gd#L37) is only allowing your direction to be 0, 45, 90, 135, 180, 225, 270, 315, 360 degrees which limit your range of motion. Also, this is a nitpick, but the diagonal motions feel less smooth than the unidirectional movements. 
___
### Stage 5 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The student met the objective of the four-way speed-up zone. They implemented the logic of the push box in much simpler ways than I did. They repurposed the push box edge calculations to see if the player was in the speed-up. If they were outside the first box then the [if statement](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/push_zone.gd#L51C45-L51C77) would execute the camera movement. The next [if statement](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/push_zone.gd#L67) was just the repurposed code from the original push box code to the current push box in the four-way speed up zone. If I redo the code for part 5, I would use this approach since it is much simpler.

___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
Didn't really find any notable infractions to talk about.

#### Style Guide Exemplars ####
The student followed the style guide well. They were better than I did. One example is how, for every comment, he had one space from the "#".

___
#### Put style guide infractures ####
N/A
___

# Best Practices #


### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

They were also very consistent in where they provided explanations of what the segment does. I saw an example of a comment block that could have been shorter while providing the same context. For example [here](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/lerp_smoothing_pl.gd#L47) and [here](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/target_focus.gd#L84) felt like an excessive amount lines of comments. At most, 3-4 lines of comments are necessary to communicate all the information to the viewer. These mega chunks made the code feel cluttered.


#### Best Practices Exemplars ####
The most readable document to me was [push_zone.gd](https://github.com/ensemble-ai/exercise-2-camera-control-brianl02/blob/4d025f41a32d30fe5a1dd26672fd9082d21bac42/Obscura/scripts/camera_controllers/push_zone.gd#L34) script. He did an excellent job here, consistently formatting and delivering all the information the reader needs. I needed to be more consistent in my formatting, and I'll take some of what this student did in my coding.

Overall, the student did a great job on this programming assignment.



