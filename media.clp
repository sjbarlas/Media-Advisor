(reset)

(import javax.swing.*)
(import javax.swing.JFrame)
(import javax.swing.border.EmptyBorder) ; frame space
(import java.awt.event.ActionListener)
(import java.awt.BorderLayout)
(import java.awt.GridLayout) ; for the button
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
(defrule go-rule-3
	=>
	(printout t "Is feedback required?" crlf)
	(bind ?f (read))
	(assert (feedback-required ?f))
	(run)
)
; *********** THIRD RULE *********** 

; All the rules from 1-14 and 3 ORIGINALS
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
	(feedback-required yes)
	=>
	(assert (medium workshop))
)

(defrule rule-10
	(stimulus-situation sumbolic)
	(stimulus-response analytical)
	(feedback-required yes)
	=>
	(assert (medium lecture-tutorial))
)

(defrule rule-11
	(stimulus-situation visual)
	(stimulus-response oral)
	(feedback-required no)
	=>
	(assert (medium videocassette))
)

(defrule rule-12
	(stimulus-situation visual)
	(stimulus-response oral)
	(feedback-required yes)
	=>
	(assert (medium lecture-tutorial))
)

(defrule rule-13
	(stimulus-situation verbal)
	(stimulus-response analytical)
	(feedback-required yes)
	=>
	(assert (medium lecture-tutorial))
)

(defrule rule-14
	(stimulus-situation verbal)
	(stimulus-response oral)
	(feedback-required yes)
	=>
	(assert (medium role-play exercises))
)

; *********** ORIGINAL3 *********** 
(defrule rule-ORIGINAL3
	(stimulus-situation outdoor)
	(stimulus-response athletic)
	(feedback-required yes)
	=>
	(assert (medium practise-play))
)
; *********** ORIGINAL3 ***********

; *********** GLOBALS ***********
; DEFGLOBALS
	(defglobal ?*frame* = 0) # Screen frame
	(defglobal ?*jAndE* = 0) # Storage
	(defglobal ?*environment-box* = 0) # Environments
	(defglobal ?*job-box* = 0) # Jobs
	(defglobal ?*feedback-required* = 0) # Feedback
	(defglobal ?*output-medium* = 0) # Advisable medium
 
; Frame creation
(deffunction frame ()
	(bind ?*frame* (new JFrame "MEDIA ADVISOR WITH JESS"))
	(bind ?*jAndE* (?*frame* getContentPane))
	(?*jAndE* setLayout (new GridLayout 5 5 5 5))
	(?*jAndE* setBorder (new EmptyBorder 10 10 10 10))
)
 
; Storing the Jobs and Environments
(deffunction storing ()
	; Environment drop down menu
	(?*jAndE* add (new JLabel "Environment of the trainee:")) ; text
	(bind ?*environment-box* (new JComboBox (list ; drop down list
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
	(?*jAndE* add ?*environment-box*)
 
	; Job drop down menu
	(?*jAndE* add (new JLabel "Job of the trainee:"))
	(bind ?*job-box* (new JComboBox (list
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
	(?*jAndE* add ?*job-box*)
 
	; Feedback
	(?*jAndE* add (new JLabel "Feedback required:"))
	(bind ?*feedback-required* (new JComboBox (list
		"yes"
		"no")))
	(?*jAndE* add ?*feedback-required*)
	
	; Button
	(?*jAndE* add (new JPanel)) ; container for button
	(bind ?button (new JButton "Click for medium"))
	(?*jAndE* add ?button)
 
	; Medium Output
	(?*jAndE* add (new JLabel "Advisable medium is:"))
	(bind ?*output-medium* (new JLabel))
	(?*jAndE* add ?*output-medium*)
 
	; Button behaviour
	(?button addActionListener
		(implement ActionListener using
			(lambda (?name ?event)
				(click-button
					(?*environment-box* getSelectedItem)
					(?*job-box* getSelectedItem)
					(?*feedback-required* getSelectedItem)
				)
			)
		)
	)
)

; Displaying the frame
(deffunction display ()
	(?*frame* pack)
	(?*frame* setVisible TRUE) ; show the text
	(?*frame* setLocationRelativeTo nil) ; centre frame on screen
)

; Opening the frame
(defrule open
	(initial-fact)
	=>
	(frame) ; creating the GUI
	(storing) ; jobs and environments
	(display) ; frame appears on screen
)
 
(reset)
(run)
