//enter name of the video here
s = "S2-12-60ms-20200424_01";
//enter the path to the file where you want the results to be output
dir = "D:/test.txt";

// if there's extra bits that are not gel -- increase t1 and t2
// if parts of gel are missing -- decrease t1 and t2
// original values: t1 = 89; t2 = 174;
t1 = 89;
t2 = 174;

// size of the particles that are removed -- consider adjusting
//original value sz=500;
sz  = 500;

  Dialog.create("Gel Tracking: Parameters");
  Dialog.addMessage("Before starting, import the video as a virtual stack and convert it to greyscale.");
  Dialog.addString("Name of the video:", s);
  Dialog.addString("Path to the output file:", dir);
  Dialog.addMessage("Thresholds for binarising images:\n If there are extra bits that are not gel -- increase T1 and T2; \n If parts of gel are missing -- decrease T1 and T2");
  Dialog.addNumber("T1:", t1);	
  Dialog.addNumber("T2:", t2);
  Dialog.addMessage("Removing the unwanted particles: \n Anything of size less than Sz will be removed");
  Dialog.addNumber("Sz [pixel^2]:", sz);
  Dialog.show();
  s = Dialog.getString();
  dir = Dialog.getString();
  t1 = Dialog.getNumber();
  t2 = Dialog.getNumber();
  sz = Dialog.getNumber();
  
//commment all the "close" statements while adjusting the parameters to keep the images open
//those are there just to save RAM memory when large videos are analysed


run("Duplicate...", "duplicate");
// close(s+".avi");
run("Z Project...", "projection=[Max Intensity]");
imageCalculator("Difference create stack", s+"-1.avi","MAX_"+s+"-1.avi");
close("MAX_"+s+"-1.avi");
 close(s+"-1.avi");
selectWindow("Result of "+s+"-1.avi");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT", "stack");
setAutoThreshold("Default dark");
setThreshold(t1, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Analyze Particles...", "size=0-"+sz+" show=Masks stack");
run("Invert", "stack");
imageCalculator("AND create stack", "Result of "+s+"-1.avi","Mask of Result of "+s+"-1.avi");
 close("Result of "+s+"-1.avi");
 close("Mask of Result of "+s+"-1.avi");
selectWindow("Result of Result of "+s+"-1.avi");
run("Dilate", "stack");
run("Fill Holes", "stack");
run("Gaussian Blur...", "sigma=5 stack");
setAutoThreshold("Default dark");
setThreshold(t2, 255);
run("Convert to Mask", "method=Default background=Dark black");
run("Skeletonize", "stack");
run("Save XY Coordinates...", "background=0 suppress process save="+dir);


//Made by Ivan Tanasijevic,DAMTP December 2020