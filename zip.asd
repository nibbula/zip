(defpackage :zip-system
  (:use :cl :asdf))
(in-package :zip-system)

(defclass silent-source-file (cl-source-file) ())

#+sbcl
(defmethod perform :around ((o compile-op) (s silent-source-file))
  (handler-bind ((sb-ext:compiler-note #'muffle-warning))
    (call-next-method)))

(defsystem :zip
    :default-component-class silent-source-file
    :depends-on (:salza #+sbcl :sb-simple-streams)
    :components ((:file "package")
		 (:file dependent
			:pathname
			#+sbcl "sbcl"
			#+allegro "acl"
			#-(or sbcl allegro) #.(error "unsupported lisp")
			:depends-on ("package"))
		 (:file "ifstar" :depends-on ("package"))
		 (:file "inflate" :depends-on ("package" "ifstar"))
		 (:file "zip" :depends-on ("inflate" dependent))))
