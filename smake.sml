(* A simple project-scaffolding tool for SML *)

(*
  This will make a program with the following structure:
  project/          ← the root folder
  project/README.md ← a readme file
  project/src/      ← the folder containing the source code
  project.sml       ← a file which will `use' the actual src files and serve as a compiler target
*)

structure Smake = struct

fun printNF s = TextIO.output (TextIO.stdOut, s)

fun callForHelp () =
  (printNF "Usage:\n";
   printNF "  smake new <name> => creates a new project in dir `name'\n";
   TextIO.flushOut TextIO.stdOut)

fun printToFile file text =
  let
      val strm = TextIO.openOut file
      fun defer () = TextIO.closeOut strm
  in
      (TextIO.output (strm, text);
       TextIO.flushOut strm;
       defer ())
  end
      
			      
fun new name =
  let
      open OS.FileSys
      fun subDir (p, c) = p ^ "/" ^ c
      val this = subDir (getDir (), name)
      val rmString = "#" ^ name ^ "\n"
  in
      (mkDir this;
       mkDir (subDir (this, "src"));
       printToFile (subDir (this, "README.md")) rmString;
       printToFile (subDir (this, name ^ ".sml")) "")
  end
       		   
fun crash s =
  (printNF "Error: ";
   printNF s;
   printNF "\n";
   TextIO.flushOut TextIO.stdOut;
   callForHelp ())
   
		   
fun dispatch () =
  case CommandLine.arguments () of
      "new"::name::trash => new name
    | trash => crash "Unknown arguments!"
		     
end

fun main () = Smake.dispatch ()
