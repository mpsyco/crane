(defpackage :crane.utils
  (:use :cl :anaphora :iter :annot.doc))
(in-package :crane.utils)
(annot:enable-annot-syntax)

@doc "Calculates the difference between two plists, returning the result as a
list of ([property] [old value] [new value])"
@export
(defun diff-plist (plist-a plist-b &key (test #'eql))
  (remove-if
    #'null
    (loop for slot in plist-a by #'cddr appending
      (if slot
          (let ((val-a (getf plist-a slot))
                (val-b (getf plist-b slot)))
            (if (funcall test val-a val-b)
                (list nil)
                (list slot (list val-a val-b))))))))

@doc "Load a whole file into a string."
@export
(defun slurp-file (path)
  ;; Credit: http://www.ymeme.com/slurping-a-file-common-lisp-83.html
  (with-open-file (stream path)
    (let ((seq (make-array (file-length stream) :element-type 'character :fill-pointer t)))
      (setf (fill-pointer seq) (read-sequence seq stream))
      seq)))

@doc "Return the keys of a plist."
@export
(defun plist-keys (plist)
  (iter (for key in plist by #'cddr)
        (collecting key)))

@doc "Reintern a symbol into the keyword package."
@export
(defun make-keyword (symbol)
  (intern (symbol-name symbol) :keyword))
