(reset)

(import javax.swing.*)
(import javax.swing.JFrame)
(import javax.swing.border.EmptyBorder)
(import java.awt.event.ActionListener)
(import java.awt.BorderLayout)
(import java.awt.GridLayout)
(import java.awt.Color)
	
; *********** FIRST RULE *********** 
(defrule go-rule-1
    =>
    (printout t "What sort of environment is a trainee dealing with on the job?" crlf)
    (bind ?e (read))
    (assert (environment ?e))
	(run)
)
; *********** FIRST RULE *********** 
; *********** SECOND RULE *********** 
(defrule go-rule-2
    =>
    (printout t "What sort of job is a trainee dealing with?" crlf)
    (bind ?j (read))
    (assert (job ?j))
    (run)
)
; *********** SECOND RULE *********** 
; *********** THIRD RULE *********** 
;(defrule go-rule-3
;	=>
;	(printout t "What medium is it?" crlf)
;	(bind ?m (read))
;	(assert (medium ?m))
;	(run)
;)
; *********** THIRD RULE *********** 

; All the rules from 1-14
(defrule rule-1
	(environment papers | manuals | documents | textbooks)
	=>
	(assert (stimulus-situation verbal))
)

(defrule rule-2
	(environment pictures | illustrations | photographs | diagrams)
	=>
	(assert (stimulus-situation visual))
)

(defrule rule-3
	(environment machines | buildings | tools)
	=>
	(assert (stimulus-situation physical object))
)

(defrule rule-4
	(environment numbers | formulas | computer programs)
	=>
	(assert (stimulus-situation symbolic))
)

; *********** ORIGINAL1 *********** 
(defrule rule-ORIGINAL1
	(environemnt equipment | ground | oustide)
	=>
	(assert (stimulus-situation outdoor))
)
; *********** ORIGINAL1 ***********
 
(defrule rule-5
	(job lecturing | advising | counselling)
	=>
	(assert (stimulus-response oral))
)

(defrule rule-6
	(job building | repairing | troubleshooting)
	=>
	(assert (stimulus-response hands-on))
)

(defrule rule-7
	(job writing | typing | drawing)
	=>
	(assert (stimulus-response documented))
)

(defrule rule-8
	(job evaluating | reasoning | investigating)
	=>
	(assert (stimulus-response analytical))
)

; *********** ORIGINAL2 *********** 
(defrule rule-ORIGINAL2
	(job catching | playing | hitting)
	=>
	(assert (stimulus-response athletic))
)
; *********** ORIGINAL2 *********** 

(defrule rule-9
	(stimulus-situation physical object)
	(stimulus-response hands-on)
	(feedback-required TRUE)
	=>
	(assert (medium workshop))
)

(defrule rule-10
	(stimulus-situation sumbolic)
	(stimulus-response analytical)
	(feedback-required TRUE)
	=>
	(assert (medium lecture-tutorial))
)

(defrule rule-11
	(stimulus-situation visual)
	(stimulus-response oral)
	(feedback-required FALSE)
	=>
	(assert (medium videocassette))
)

(defrule rule-12
	(stimulus-situation visual)
	(stimulus-response oral)
	(feedback-required TRUE)
	=>
	(assert (medium lecture-tutorial))
)

(defrule rule-13
	(stimulus-situation verbal)
	(stimulus-response analytical)
	(feedback-required TRUE)
	=>
	(assert (medium lecture-tutorial))
)

(defrule rule-14
	(stimulus-situation verbal)
	(stimulus-response oral)
	(feedback-required TRUE)
	=>
	(assert (medium role-play exercises))
)

; *********** ORIGINAL3 *********** 
(defrule rule-ORIGINAL3
	(stimulus-situation outdoor)
	(stimulus-response athletic)
	(feedback-required TRUE)
	=>
	(assert (medium practise-play))
)
; *********** ORIGINAL3 ***********

; DEFGLOBALS
	(defglobal ?*frame* = 50)
	(defglobal ?*content* = 0)
	(defglobal ?*envbox* = 0)
	(defglobal ?*jobbox* = 0)
	(defglobal ?*feedback* = 0)
	(defglobal ?*output* = 0)

; Fired when nothing matches
(defrule default
	?done <- (done)
	?situation <- (stimulus-situation ?)
	?response <- (stimulus-response ?)
	?feedback <- (feedback-required ?)
	=>
	(retract ?situation)
	(retract ?response)
	(retract ?feedback)
	(assert (medium unknown))
)
 
; Change text on the label when Medium matches
(defrule result
	?done <- (done)
	?medf <- (medium ?m)
	=>
	(retract ?done)
	(retract ?medf)
	(set-output ?m)
	(printout t "Medium is " ?m crlf)
)
 
; Function for finding Medium
(deffunction find-medium (?e ?j ?f)
	(assert (environment ?e))
	(assert (job ?j))
	(assert (feedback-required ?f))
	(run)
	(assert (done))
	(run)
)
 
; Frame creation
(deffunction create-frame ()
	(bind ?*frame* (new JFrame "Media Advisor with Jess"))
	(bind ?*content* (?*frame* getContentPane))
	(?*content* setLayout (new GridLayout 5 2 5 5))
	(?*content* setBorder (new EmptyBorder 10 10 10 10))
)
 
; Frame Contents and Panels
(deffunction add-content ()
	(?*content* add (new JLabel "Environment of the trainee:"))
	(bind ?*envbox* (new JComboBox (list
		"papers"
		"manuals"
		"documents"
		"textbooks"
		"pictures"
		"illustrations"
		"photographs"
		"diagrams"
		"machines"
		"buildings"
		"tools"
		"numbers"
		"formulas"
		"computer programs"
		"equipment"
		"ground"
		"outside")))
	(?*content* add ?*envbox*)
 
	(?*content* add (new JLabel "Job of the trainee:"))
	(bind ?*jobbox* (new JComboBox (list
		"lecturing"
		"advising"
		"counselling"
		"building"
		"repairing"
		"troubleshooting"
		"writing"
		"typing"
		"drawing"
		"evaluating"
		"reasoning"
		"investigating"
		"catching"
		"playing"
		"hitting")))
	(?*content* add ?*jobbox*)
 
	(?*content* add (new JLabel "Feedback required?"))
	(bind ?*feedback* (new JCheckBox))
	(?*feedback* setSelected TRUE)
	(?*content* add ?*feedback*)
 
	(?*content* add (new JPanel)) ; Button
	(bind ?button (new JButton "Click for medium"))
	(?*content* add ?button)
 
	(?*content* add (new JLabel "Suitable medium is:"))
	(bind ?*output* (new JLabel))
	(?*content* add ?*output*)
 
	; Button behaviour
	(?button addActionListener
		(implement ActionListener using
			(lambda (?name ?event)
				(find-medium
					(?*envbox* getSelectedItem)
					(?*jobbox* getSelectedItem)
					(?*feedback* isSelected)
				)
			)
		)
	)
)
 
; Showing the Frame
(deffunction show-frame ()
	(?*frame* pack)
	(?*frame* setVisible TRUE) ;show the text
	(?*frame* setLocationRelativeTo nil) ;centre GUI on screen
)
 
; Output label text change
(deffunction set-output (?t)
        (?*output* setText ?t)
)

; Main program init
(defrule init
	?f <- (initial-fact)
	=>
	(retract ?f)
	(create-frame)
	(add-content)
	(show-frame)
)
 
(reset)
(run)
