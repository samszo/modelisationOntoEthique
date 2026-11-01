import { Tool } from "@mastra/core/tools";
import { z } from "zod";
import { getOmk } from "../lib/omeka/omk";
import { buildTemplateForm } from "../lib/omeka/templateForm";

// Description du formulaire d'un resource template Omeka S
export const buildResourceTemplateForm = new Tool({
  name: "build-resource-template-form",
  description: "Génère la description du formulaire de saisie d'un resource template Omeka S : champs, types de données, listes des custom vocabs, item sets, classe suggérée et annotations de valeur.",
  schema: z.object({ templateId: z.number().int().positive() }),
  execute: async ({ data }) => buildTemplateForm(await getOmk(), (data as { templateId: number }).templateId),
});
